//
//  YTSwiftyPlayer.swift
//  YTSwiftyPlayer
//
//  Created by Ryo Ishikawa on 12/30/2017
//  Copyright © 2017 Ryo Ishikawa. All rights reserved.
//
// WKWebViewの構成と公開操作。状態の更新はEvents拡張と共有する。
import UIKit
import WebKit

/**
 * `YTSwiftyPlayer` is a subclass of `WKWebView` that support fully Youtube IFrame API.
 * It can be instantiated only programmatically.
 * - note: This class is not support interface builder due to use `WKWebView`.
 * For more information: [https://developer.apple.com/documentation/webkit/wkwebview](https://developer.apple.com/documentation/webkit/wkwebview)
 */
open class YTSwiftyPlayer: WKWebView {

    /// The property for easily set auto playback.
    open var autoplay = false

    open weak var delegate: YTSwiftyPlayerDelegate?

    open internal(set) var isMuted = false

    open internal(set) var playbackRate: Double = 1.0

    open internal(set) var availablePlaybackRates: [Double] = [1]

    @available(*, deprecated, message: "YouTubeは画質一覧の取得をサポートしていません。")
    open internal(set) var availableQualityLevels: [YTSwiftyVideoQuality] = []

    open internal(set) var bufferedVideoRate: Double = 0

    open internal(set) var currentPlaylist: [String] = []

    open internal(set) var currentPlaylistIndex: Int = 0

    open internal(set) var currentVideoURL: String?

    open internal(set) var currentVideoEmbedCode: String?

    open internal(set) var playerState: YTSwiftyPlayerState = .unstarted

    open internal(set) var playerQuality: YTSwiftyVideoQuality = .unknown

    open internal(set) var duration: Double?

    open internal(set) var currentTime: Double = 0.0
 
    internal var playerVars: [String: AnyObject] = [:]

    private let callbackHandlers: [YTSwiftyPlayerEvent] = [
        .onYoutubeIframeAPIReady,
        .onYouTubeIframeAPIFailedToLoad,
        .onReady,
        .onStateChange,
        .onQualityChange,
        .onPlaybackRateChange,
        .onApiChange,
        .onError,
        .onUpdateCurrentTime
    ]

    static private var defaultConfiguration: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        return config
    }

    private var scriptHandlerNames: [String] {
        return callbackHandlers.map { $0.rawValue } + [PlayerClientIdentity.autoplayBlockedEvent]
    }

    public enum Const {
        /// 従来の明示的なURL指定との互換性を維持する。
        public static let basePlayerURLString = "https://www.youtube-nocookie.com"

        /// ローカルHTMLのRefererを利用アプリのBundle IDから生成する。
        public static var defaultBaseURLString: String {
            return PlayerClientIdentity.baseURLString(bundleIdentifier: Bundle.main.bundleIdentifier)
        }
    }

    public init(frame: CGRect = .zero, playerVars: [String: AnyObject]) {
        let config = YTSwiftyPlayer.defaultConfiguration
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        
        super.init(frame: frame, configuration: config)
        
        scriptHandlerNames.forEach {
            userContentController.add(WeakWKScriptMessageHandler(delegate: self), name: $0)
        }
        
        commonInit()
        
        self.playerVars = playerVars
    }

    public init(frame: CGRect = .zero, playerVars: [VideoEmbedParameter] = []) {
        let config = YTSwiftyPlayer.defaultConfiguration
        let userContentController = WKUserContentController()
        config.userContentController = userContentController

        super.init(frame: frame, configuration: config)

        scriptHandlerNames.forEach {
            userContentController.add(WeakWKScriptMessageHandler(delegate: self), name: $0)
        }

        commonInit()

        guard !playerVars.isEmpty else { return }
        var params: [String: AnyObject] = [:]
        playerVars.forEach {
            let property = $0.property
            params[property.key] = property.value
        }
        self.playerVars = params
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func buildPlayerParameters() -> [String: AnyObject] {
        let events: [String: AnyObject] = {
            var registerEvents: [String: AnyObject] = [:]
            scriptHandlerNames.forEach {
                registerEvents[$0] = $0 as AnyObject
            }
            return  registerEvents
        }()

        var parameters = [
            "width": "100%" as AnyObject,
            "height": "100%" as AnyObject,
            "events": events as AnyObject,
            "playerVars": playerVars as AnyObject,
            ]

        if let videoID = playerVars["videoId"] {
            parameters["videoId"] = videoID
        }
        return parameters
    }

    public func setPlayerParameters(_ parameters: [String: AnyObject]) {
        self.playerVars = parameters
    }

    public func setPlayerParameters(_ parameters: [VideoEmbedParameter]) {
        var params: [String: AnyObject] = [:]
        parameters.forEach {
            let property = $0.property
            params[property.key] = property.value
        }
        self.playerVars = params
    }

    public func playVideo() {
        evaluatePlayerCommand("playVideo()")
    }

    public func stopVideo() {
        evaluatePlayerCommand("stopVideo()")
    }

    public func seek(to seconds: Int, allowSeekAhead: Bool) {
        evaluatePlayerCommand("seekTo(\(seconds),\(allowSeekAhead ? 1 : 0))")
    }

    public func pauseVideo() {
        evaluatePlayerCommand("pauseVideo()")
    }

    public func clearVideo() {
        evaluatePlayerCommand("clearVideo()")
    }

    public func mute() {
        evaluatePlayerCommand("mute()") { [weak self] result in
            guard result != nil else { return }
            self?.isMuted = true
        }
    }

    public func unMute() {
        evaluatePlayerCommand("unMute()") { [weak self] result in
            guard result != nil else { return }
            self?.isMuted = false
        }
    }

    public func previousVideo() {
        evaluatePlayerCommand("previousVideo()")
    }

    public func nextVideo() {
        evaluatePlayerCommand("nextVideo()")
    }

    public func playVideo(at index: Int) {
        evaluatePlayerCommand("playVideoAt(\(index))")
    }

    public func setPlayerSize(width: Int, height: Int) {
        evaluatePlayerCommand("setSize(\(width),\(height))")
    }

    public func setPlaybackRate(_ suggestedRate: Double) {
        evaluatePlayerCommand("setPlaybackRate(\(suggestedRate))")
    }

    @available(*, deprecated, message: "YouTubeが再生画質を自動選択するため、この指定に効果はありません。")
    public func setPlaybackQuality(_ suggestedQuality: YTSwiftyVideoQuality) {
        evaluatePlayerCommand("setPlaybackQuality(\(suggestedQuality.rawValue))")
    }

    public func setLoop(_ loopPlaylists: Bool) {
        evaluatePlayerCommand("setLoop(\(loopPlaylists))")
    }

    public func setShuffle(_ shufflePlaylist: Bool) {
        evaluatePlayerCommand("setShuffle(\(shufflePlaylist))")
    }

    /// suggestedQualityはYouTubeに無視される。既存の呼び出し形式を維持するために残す。
    public func cueVideo(videoID: String, startSeconds: Int = 0, suggestedQuality: YTSwiftyVideoQuality = .large) {
        evaluatePlayerCommand("cueVideoById('\(videoID)',\(startSeconds),'\(suggestedQuality.rawValue)')")
    }

    /// suggestedQualityはYouTubeに無視される。既存の呼び出し形式を維持するために残す。
    public func loadVideo(videoID: String, startSeconds: Int = 0, suggestedQuality: YTSwiftyVideoQuality = .large) {
        evaluatePlayerCommand("loadVideoById('\(videoID)',\(startSeconds),'\(suggestedQuality.rawValue)')")
    }

    public func cueVideo(contentURL: String, startSeconds: Int = 0, suggestedQuality: YTSwiftyVideoQuality = .large) {
        evaluatePlayerCommand("cueVideoByUrl('\(contentURL)',\(startSeconds),'\(suggestedQuality.rawValue)')")
    }

    public func loadVideo(contentURL: String, startSeconds: Int = 0, suggestedQuality: YTSwiftyVideoQuality = .large) {
        evaluatePlayerCommand("loadVideoByUrl('\(contentURL)',\(startSeconds),'\(suggestedQuality.rawValue)')")
    }

    public func cuePlaylist(playlist: [String], startIndex: Int = 0, startSeconds: Int = 0, suggestedQuality: YTSwiftyVideoQuality = .large) {
        evaluatePlayerCommand("cuePlaylist('\(playlist.joined(separator: ","))',\(startIndex),\(startSeconds),'\(suggestedQuality.rawValue)')")
    }

    public func loadPlaylist(playlist: [String], startIndex: Int = 0, startSeconds: Int = 0, suggestedQuality: YTSwiftyVideoQuality = .large) {
        evaluatePlayerCommand("loadPlaylist('\(playlist.joined(separator: ","))',\(startIndex),\(startSeconds),'\(suggestedQuality.rawValue)')")
    }

    public func loadPlaylist(withVideoIDs ids: [String]) {
        evaluatePlayerCommand("loadPlaylist('\(ids.joined(separator: ","))')")
    }

    // MARK: - Private Methods
    
    private func commonInit() {
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    // Evaluate javascript command and convert to simple error(nil) if an error is occurred.
    internal func evaluatePlayerCommand(_ commandName: String, callbackHandler: ((Any?) -> ())? = nil) {
        let command = "player.\(commandName);"
        evaluateJavaScript(command) { (result, error) in
            callbackHandler?(error != nil ? nil : result)
        }
    }

    // WKWebViewの破棄に後処理を任せる。非隔離deinitからUIKitを呼び出さない。

    private class WeakWKScriptMessageHandler: NSObject, WKScriptMessageHandler {
        weak var delegate: WKScriptMessageHandler?

        init(delegate:WKScriptMessageHandler) {
            self.delegate = delegate
            super.init()
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            self.delegate?.userContentController(userContentController, didReceive: message)
        }
    }
}
