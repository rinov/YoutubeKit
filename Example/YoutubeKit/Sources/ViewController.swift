//
//  ViewController.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017.
//  Copyright (c) 2017 Ryo Ishikawa. All rights reserved.
//

import UIKit
import YoutubeKit

final class ViewController: UIViewController {

    private var player: YTSwiftyPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Note: Run this example, You might be face on following message.
        // `[Process] kill() returned unexpected error 1`
        // This is a bug of WKWebView in iOS13 and that will be fixed in 13.4 release.

        // Create a new player
        player = YTSwiftyPlayer(
            frame: .zero,
            playerVars: [
                .playsInline(false),
                .videoID("9AALILYu58w"),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(true)
            ])

        view = player
        player.delegate = self

        // Load video player
        let playerPath = Bundle(for: ViewController.self).path(forResource: "player", ofType: "html")!
        let htmlString = try! String(contentsOfFile: playerPath, encoding: .utf8)
        player.loadPlayerHTML(htmlString)

        // (Optional) Create a new request for video list
        // Please make sure to set your API key in `AppDelegate`.
        fetchVideoList()
    }

    private func fetchVideoList() {
        let request = VideoListRequest(part: [.id, .snippet, .contentDetails], filter: .chart)
        YoutubeAPI.shared .send(request) { result in
            switch result {
            case .success(let response):
                print("YoutubeAPI success: \(response)")
            case .failure(let error):
                print("YoutubeAPI failure: \(error)")
            }
        }
    }
}

extension ViewController: YTSwiftyPlayerDelegate {
    
    func playerReady(_ player: YTSwiftyPlayer) {
        print(#function)
        // After loading a video, player API is available.
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
