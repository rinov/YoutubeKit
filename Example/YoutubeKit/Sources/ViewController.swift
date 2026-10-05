//
//  ViewController.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017.
//  Copyright (c) 2017 Ryo Ishikawa. All rights reserved.
//  Demonstrates playback and logs player failures for release smoke tests.
//

import UIKit
import YoutubeKit

final class ViewController: UIViewController {

    private var player: YTSwiftyPlayer!

    private let youtubeAPI = YoutubeAPI.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a new player
        player = YTSwiftyPlayer(
            frame: .zero,
            playerVars: [
                .playsInline(false),
                .videoID("_6u6UrtXUEI"),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(true)
            ])

        view = player
        player.delegate = self
        player.loadDefaultPlayer()
        fetchVideoList()
    }

    private func fetchVideoList() {
        let request = VideoListRequest(part: [.id, .snippet, .contentDetails], filter: .chart)

        // Please make sure to set your key in `AppDelegate`.
        youtubeAPI.send(request) { result in
            switch result {
            case .success(let response):
                print("YoutubeAPI success: \(response)")
            case .failure(let error):
                print("YoutubeAPI failure: \(error)")
            }
        }
    }
}

// WKWebViewの通知はメインスレッドで届く。既存の非隔離delegate契約をExample側で適合する。
#if compiler(>=6.0)
extension ViewController: @preconcurrency YTSwiftyPlayerDelegate {}
#else
extension ViewController: YTSwiftyPlayerDelegate {}
#endif

extension ViewController {
    
    func playerReady(_ player: YTSwiftyPlayer) {
        print(#function)
        // Player API is available after loading a video.
        // e.g. player.mute()
    }
    
    func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
        print("\(#function): \(currentTime)")
    }
    
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        print("\(#function): \(state)")
    }
    
    func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
        print("\(#function): \(playbackRate)")
    }
    
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        print("\(#function): \(error)")
    }

    // The typed callback covers legacy cases; this also reports 153 and future codes.
    func player(_ player: YTSwiftyPlayer, didReceiveErrorCode code: Int) {
        print("YouTube player error code: \(code)")
    }

    func autoplayBlocked(_ player: YTSwiftyPlayer) {
        print("Autoplay was blocked. Tap the player's play button to continue.")
    }
    
    func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
        print("\(#function): \(quality)")
    }
    
    func apiDidChange(_ player: YTSwiftyPlayer) {
        print(#function)
    }
    
    func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
        print(#function)
    }
    
    func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
        print(#function)
    }
}
