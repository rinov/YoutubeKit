// プレイヤーのイベント処理。既存の型付き通知を維持し、新しいイベントも受け取る。
import WebKit

extension YTSwiftyPlayer: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == PlayerClientIdentity.autoplayBlockedEvent {
            delegate?.autoplayBlocked(self)
            return
        }
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
            guard let code = message.body as? Int else { return }
            // enumへのcase追加は利用側の網羅的switchを壊すため、生コードで補完する。
            if let error = YTSwiftyPlayerError(rawValue: code) {
                delegate?.player(self, didReceiveError: error)
            }
            delegate?.player(self, didReceiveErrorCode: code)
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
