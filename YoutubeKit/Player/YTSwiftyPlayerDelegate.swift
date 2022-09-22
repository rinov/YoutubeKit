//
//  YTSwiftyPlayerDelegate.swift
//  YTSwiftyPlayer
//
//  Created by Ryo Ishikawa on 12/30/2017
//  Copyright © 2017 Ryo Ishikawa. All rights reserved.
//

// MARK: - YTSwiftyPlayerDelegate
public protocol YTSwiftyPlayerDelegate: AnyObject {

    /**
     - parameters:
        - player: The current active player instance.
        - state: The updated player state.
     */
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState)
    
    /**
     - parameters:
        - player: The current active player instance.
        - quality: The updated video quality.
     */
    func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality)

    /**
     - parameters:
        - player: The current active player instance.
        - error: The received error.
     */
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError)
 
    /**
     - parameters:
        - player: The current active player instance.
        - currentTime: The updated current time of video duration.
     */
    func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double)
    
    /**
     - parameters:
        - player: The current active player instance.
        - playbackRate: The updated playback rate of video.
     */
    func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double)
    
    /**
      Notify that the player can be play a video.
     
     - parameters:
        - player: The current active player instance.
     */
    func playerReady(_ player: YTSwiftyPlayer)

    /**
      This event is issued to indicate that the player has read (or unloaded) the module with a direct API method.
     
     - parameters:
        - player: The current active player instance.
     */
    func apiDidChange(_ player: YTSwiftyPlayer)

    /**
      API calls this function when downloading JavaScript for player API on page. This will allow you to use the API on the page. With this function you can create a player object to display when the page is loaded.
     
     - parameters:
        - player: The current active player instance.
     */
    func youtubeIframeAPIReady(_ player: YTSwiftyPlayer)

    /**
      API calls this function when JavaScript for player API loading is failed on page.

     - parameters:
        - player: The current active player instance.
     */
    func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer)
}

// Default implementation of delegate methods, These delegate functions are option.
public extension YTSwiftyPlayerDelegate {

    /**
      * Invoked when player state has changed.
      *
      * - parameters:
      *     - player: The player instance that is reflected latest state.
      *     - state: The current player state.
      */
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {}
    
    /**
     * Invoked when video quality has changed.
     *
     * - parameters:
     *     - player: The player instance that is reflected a new quality.
     *     - quality: The current video quality.
     */
    func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {}

    /**
     * Invoked when error has occurred.
     *
     * - parameters:
     *     - player: The player instance where the error has occurred.
     *     - error: The error containing a reason.
     */
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {}
    
    /**
     * Invoked when video duration has changed.
     *
     * - parameters:
     *     - player: The player instance that is updated a latest duration.
     *     - currentTime: The current video duration.
     */
    func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {}
    
    /**
     * Invoked when playback rate has changed.
     *
     * - parameters:
     *     - player: The player instance that is updated a new playback.
     *     - playbackRate: The current player state.
     */
    func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {}
    
    /**
     * Invoked when player is ready to play a video.
     *
     * - parameters:
     *     - player: The player instance that has ready to play a video.
     */
    func playerReady(_ player: YTSwiftyPlayer) {}
    
    /**
     * Invoked when API has changed.
     *
     * - parameters:
     *     - player: The player instance that API has changed.
     */
    func apiDidChange(_ player: YTSwiftyPlayer) {}
    
    /**
     * Invoked when Youtube IFrame API has ready to call.
     *
     * - parameters:
     *     - player: The player instance that has ready to call API.
     */
    func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {}

    /**
     * Invoked when Youtube IFrame API has failed to call.
     *
     * - parameters:
     *     - player: The player instance that has faile to load API .
     */
    func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {}
}
