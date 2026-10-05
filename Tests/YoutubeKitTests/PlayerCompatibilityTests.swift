// プレイヤー互換性テスト。ネットワークを使わずHTML読込とイベント通知を検証する。
import XCTest
import WebKit
@testable import YoutubeKit

final class PlayerCompatibilityTests: XCTestCase {
    func testClientIdentityUsesTheHostApplicationID() {
        XCTAssertEqual(PlayerClientIdentity.baseURLString(bundleIdentifier: "JP.Example.Player"),
                       "https://jp.example.player")
        for identifier in [nil, "", "invalid/id"] {
            XCTAssertEqual(PlayerClientIdentity.baseURLString(bundleIdentifier: identifier),
                           YTSwiftyPlayer.Const.basePlayerURLString)
        }
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testExplicitBaseURLAndParametersArePreserved() {
        let player = CapturingPlayer(playerVars: [.videoID("_6u6UrtXUEI")])
        let baseURL = "https://example.org"
        player.loadPlayerHTML("<script>var options = %@;</script>", baseURLString: baseURL)
        XCTAssertEqual(player.loadedBaseURL?.absoluteString, baseURL)
        XCTAssertTrue(player.loadedHTML?.contains("_6u6UrtXUEI") == true)
        XCTAssertFalse(player.loadedHTML?.contains("%@") == true)
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testDefaultAndLegacyLoadersUseThePackagedHTML() {
        let player = CapturingPlayer()
        player.loadDefaultPlayer()
        XCTAssertTrue(player.loadedHTML?.contains("new YT.Player") == true)
        XCTAssertEqual(player.loadedBaseURL?.absoluteString, YTSwiftyPlayer.Const.defaultBaseURLString)
        player.loadedHTML = nil
        player.loadPlayer()
        XCTAssertTrue(player.loadedHTML?.contains("new YT.Player") == true)
        player.loadDefaultPlayer(baseURLString: "https://jp.example.explicit")
        XCTAssertEqual(player.loadedBaseURL?.absoluteString, "https://jp.example.explicit")
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testError153AndUnknownErrorsReachTheNewDelegate() {
        let player = CapturingPlayer()
        let delegate = RecordingDelegate()
        player.delegate = delegate
        let missingIdentityCode = 153
        let futureErrorCode = 999
        for code in [missingIdentityCode, futureErrorCode, YTSwiftyPlayerError.videoNotFound.rawValue] {
            player.userContentController(player.configuration.userContentController,
                                         didReceive: TestMessage(name: "onError", body: code))
        }
        XCTAssertEqual(delegate.rawCodes, [missingIdentityCode, futureErrorCode, 100])
        XCTAssertEqual(delegate.legacyErrors, [.videoNotFound])
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testAutoplayBlockedIsRegisteredAndForwarded() {
        let player = CapturingPlayer()
        let delegate = RecordingDelegate()
        player.delegate = delegate
        let name = PlayerClientIdentity.autoplayBlockedEvent
        let events = player.buildPlayerParameters()["events"] as? [String: String]
        XCTAssertEqual(events?[name], name)
        player.userContentController(player.configuration.userContentController,
                                     didReceive: TestMessage(name: name, body: ""))
        XCTAssertEqual(delegate.autoplayBlocks, 1)
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testExistingDelegatesNeedNoNewMethods() {
        let player = CapturingPlayer()
        let delegate = LegacyDelegate()
        player.delegate = delegate
        player.userContentController(player.configuration.userContentController,
                                     didReceive: TestMessage(name: "onError", body: 153))
        player.userContentController(player.configuration.userContentController,
                                     didReceive: TestMessage(name: PlayerClientIdentity.autoplayBlockedEvent, body: ""))
        XCTAssertTrue(player.delegate === delegate)
    }
}

// WKWebViewの公開読込入口を捕捉し、外部のYouTube接続にテストを依存させない。
private final class CapturingPlayer: YTSwiftyPlayer {
    var loadedHTML: String?
    var loadedBaseURL: URL?

    override func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        loadedHTML = string
        loadedBaseURL = baseURL
        return nil
    }
}

private final class TestMessage: WKScriptMessage {
    private let eventName: String
    private let eventBody: Any
    override var name: String { eventName }
    override var body: Any { eventBody }

    init(name: String, body: Any) {
        eventName = name
        eventBody = body
        super.init()
    }
}

private final class RecordingDelegate: YTSwiftyPlayerDelegate {
    var rawCodes: [Int] = []
    var legacyErrors: [YTSwiftyPlayerError] = []
    var autoplayBlocks = 0
    func player(_ player: YTSwiftyPlayer, didReceiveErrorCode code: Int) { rawCodes.append(code) }
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) { legacyErrors.append(error) }
    func autoplayBlocked(_ player: YTSwiftyPlayer) { autoplayBlocks += 1 }
}

private final class LegacyDelegate: YTSwiftyPlayerDelegate {}
