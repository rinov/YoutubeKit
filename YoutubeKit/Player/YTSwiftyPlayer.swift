//
//  YTSwiftyPlayer.swift
//  YTSwiftyPlayer
//
//  Created by Ryo Ishikawa on 12/30/2017
//  Copyright © 2017 Ryo Ishikawa. All rights reserved.
//
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

    open private(set) var isMuted = false

    open private(set) var playbackRate: Double = 1.0

    open private(set) var availablePlaybackRates: [Double] = [1]

    open private(set) var availableQualityLevels: [YTSwiftyVideoQuality] = []

    open private(set) var bufferedVideoRate: Double = 0

    open private(set) var currentPlaylist: [String] = []

    open private(set) var currentPlaylistIndex: Int = 0

    open private(set) var currentVideoURL: String?

    open private(set) var currentVideoEmbedCode: String?

    open private(set) var playerState: YTSwiftyPlayerState = .unstarted

    open private(set) var playerQuality: YTSwiftyVideoQuality = .unknown

    open private(set) var duration: Double?

    open private(set) var currentTime: Double = 0.0
 
    private var playerVars: [String: AnyObject] = [:]

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

    public enum Const {
        /// url: https://www.youtube.com
        public static let basePlayerURLString = "https://www.youtube.com"
    }

    public init(frame: CGRect = .zero, playerVars: [String: AnyObject]) {
        let config = YTSwiftyPlayer.defaultConfiguration
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        
        super.init(frame: frame, configuration: config)
        
        callbackHandlers.forEach {
            userContentController.add(self, name: $0.rawValue)
        }
        
        commonInit()
        
        self.playerVars = playerVars
    }

    public init(frame: CGRect = .zero, playerVars: [VideoEmbedParameter] = []) {
        let config = YTSwiftyPlayer.defaultConfiguration
        let userContentController = WKUserContentController()
        config.userContentController = userContentController

        super.init(frame: frame, configuration: config)

        callbackHandlers.forEach {
            userContentController.add(self, name: $0.rawValue)
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
            callbackHandlers.forEach {
                registerEvents[$0.rawValue] = $0.rawValue as AnyObject
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

    public func setPlaybackQuality(_ suggestedQuality: YTSwiftyVideoQuality) {
        evaluatePlayerCommand("setPlaybackQuality(\(suggestedQuality.rawValue))")
    }

    public func setLoop(_ loopPlaylists: Bool) {
        evaluatePlayerCommand("setLoop(\(loopPlaylists))")
    }

    public func setShuffle(_ shufflePlaylist: Bool) {
        evaluatePlayerCommand("setShuffle(\(shufflePlaylist))")
    }

    public func cueVideo(videoID: String, startSeconds: Int = 0, suggestedQuality: YTSwiftyVideoQuality = .large) {
        evaluatePlayerCommand("cueVideoById('\(videoID)',\(startSeconds),'\(suggestedQuality.rawValue)')")
    }

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

    @available(*, deprecated, renamed: "loadPlayerHTML")
    public func loadPlayer() {
        let playerPath = Bundle(for: YTSwiftyPlayer.self).path(forResource: "player", ofType: "html")!
        guard let htmlString = try? String(contentsOfFile: playerPath, encoding: .utf8) else { return }
        loadPlayerHTML(htmlString)
    }

    public func loadDefaultPlayer() {
        guard let playerPath = Bundle.yk_frameworkBundle().path(forResource: "player", ofType: "html"),
              let htmlString = try? String(contentsOfFile: playerPath, encoding: .utf8) else { return }
        loadPlayerHTML(htmlString)
    }

    public func loadPlayerHTML(_ htmlString: String, baseURLString: String = Const.basePlayerURLString) {
        let parameters = buildPlayerParameters()
        loadPlayerHTML(htmlString, parameters: parameters, baseURLString: baseURLString)
    }

    public func loadPlayerHTML(_ htmlString: String, parameters: [String: AnyObject], baseURLString: String = Const.basePlayerURLString) {
        guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: []),
            let jsonString = String(data: json, encoding: .utf8),
            let baseUrl = URL(string: baseURLString)
            else { return }

        let html = htmlString.replacingOccurrences(of: "%@", with: jsonString)
        loadHTMLString(html, baseURL: baseUrl)
    }

    // MARK: - Private Methods
    
    private func commonInit() {
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    // Evaluate javascript command and convert to simple error(nil) if an error is occurred.
    private func evaluatePlayerCommand(_ commandName: String, callbackHandler: ((Any?) -> ())? = nil) {
        let command = "player.\(commandName);"
        evaluateJavaScript(command) { (result, error) in
            callbackHandler?(error != nil ? nil : result)
        }
    }
}

extension YTSwiftyPlayer: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = YTSwiftyPlayerEvent(rawValue: message.name) else { return }
        switch event {
        case .onReady:
            delegate?.playerReady(self)
            
            // The HTML5 video element, in certain mobile browsers, only allows playback to take place if it's initiated by a user interaction, due to this restriction, functions and parameters such as autoplay, playVideo(), loadVideoById() won't work in all mobile environments.
            // So it have to call explicit `playVideo()` to work autoplay in mobile environment.
            if autoplay || playerVars.contains(where: { $0.key == "autoplay" && String(describing: $0.value) == "1" }) {
                playVideo()
            }
            updateInfo()
        case .onStateChange:
            updateState(message.body as? Int)
            let isLoop = playerVars["loop"] as? String == "1"
            if playerState == .ended && isLoop {
                playVideo()
            }
            delegate?.player(self, didChangeState: playerState)
        case .onQualityChange:
            updateQuality(message.body as? String)
            delegate?.player(self, didChangeQuality: playerQuality)
        case .onError:
            if let message = message.body as? Int,
                let error = YTSwiftyPlayerError(rawValue: message) {
                delegate?.player(self, didReceiveError: error)
            }
        case .onUpdateCurrentTime:
            updateInfo()
            if let currentTime = message.body as? Double {
                self.currentTime = currentTime
                delegate?.player(self, didUpdateCurrentTime: currentTime)
            }
        case .onPlaybackRateChange:
            if let playbackRate = message.body as? Double {
                delegate?.player(self, didChangePlaybackRate: playbackRate)
            }
        case .onApiChange:
            delegate?.apiDidChange(self)
        case .onYoutubeIframeAPIReady:
            delegate?.youtubeIframeAPIReady(self)
        case .onYouTubeIframeAPIFailedToLoad:
            delegate?.youtubeIframeAPIFailedToLoad(self)
        }
    }

    // MARK: - Private Methods

    private func updateInfo() {
        updateMute()
        updatePlaybackRate()
        updateAvailableQualityLevels()
        updateCurrentPlaylist()
        updateCurrentVideoURL()
        updateCurrentVideoEmbedCode()
        updatePlaylistIndex()
        updateDuration()
        updateVideoLoadedFraction()
    }

    private func updateMute() {
        evaluatePlayerCommand("isMuted()") { [weak self] result in
            guard let me = self,
                let isMuted = result as? Bool else { return }
            me.isMuted = isMuted
        }
    }

    private func updatePlaybackRate() {
        evaluatePlayerCommand("getPlaybackRate()") { [weak self] result in
            guard let me = self,
                let playbackRate = result as? Double else { return }
            me.playbackRate = playbackRate
        }
    }

    private func updateVideoLoadedFraction() {
        evaluatePlayerCommand("getVideoLoadedFraction()") { [weak self] result in
            guard let me = self,
                let bufferedVideoRate = result as? Double else { return }
            me.bufferedVideoRate = bufferedVideoRate
        }
    }

    private func updateAvailableQualityLevels() {
        evaluatePlayerCommand("getAvailableQualityLevels()") { [weak self] result in
            guard let me = self,
                let availableQualityLevels = result as? [String] else { return }
            me.availableQualityLevels = availableQualityLevels
              .compactMap { YTSwiftyVideoQuality(rawValue: $0) }
        }
    }

    private func updateCurrentVideoURL() {
        evaluatePlayerCommand("getVideoUrl()") { [weak self] result in
            guard let me = self,
                let url = result as? String else { return }
            me.currentVideoURL = url
        }
    }

    private func updateCurrentVideoEmbedCode() {
        evaluatePlayerCommand("getVideoEmbedCode()") { [weak self] result in
            guard let me = self,
                let embedCode = result as? String else { return }
            me.currentVideoEmbedCode = embedCode
        }
    }

    private func updateCurrentPlaylist() {
        evaluatePlayerCommand("getPlaylist()") { [weak self] result in
            guard let me = self,
                let playlist = result as? [String] else { return }
            me.currentPlaylist = playlist
        }
    }

    private func updatePlaylistIndex() {
        evaluatePlayerCommand("getPlaylistIndex()") { [weak self] result in
            guard let me = self,
                let index = result as? Int else { return }
            me.currentPlaylistIndex = index
        }
    }

    private func updateDuration() {
        evaluatePlayerCommand("getDuration()") { [weak self] result in
            guard let me = self,
                let duration = result as? Double else { return }
            me.duration = duration
        }
    }

    private func updateState(_ message: Int?) {
        var state: YTSwiftyPlayerState = .unstarted
        if let message = message,
            let newState = YTSwiftyPlayerState(rawValue: message) {
            state = newState
        }
        playerState = state
    }

    private func updateQuality(_ message: String?) {
        var quality: YTSwiftyVideoQuality = .unknown
        if let message = message,
            let newQuality = YTSwiftyVideoQuality(rawValue: message) {
            quality = newQuality
        }
        playerQuality = quality
    }
}
