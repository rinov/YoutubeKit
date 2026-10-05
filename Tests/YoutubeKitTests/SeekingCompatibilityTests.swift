// Protect existing seek call sites and fractional positions at the JavaScript boundary.
import XCTest
@testable import YoutubeKit

final class SeekingCompatibilityTests: XCTestCase {
    #if compiler(>=5.5)
    @MainActor
    #endif
    func testIntVariablesAndMethodReferencesRemainCompatible() {
        let player = CommandCapturingPlayer()
        let seconds: Int = 30
        player.seek(to: seconds, allowSeekAhead: true)
        let typedSeek: (Int, Bool) -> Void = player.seek(to:allowSeekAhead:)
        typedSeek(seconds, false)
        let inferredSeek = player.seek(to:allowSeekAhead:)
        inferredSeek(seconds, true)
        XCTAssertEqual(player.commands, ["seekTo(30,1)", "seekTo(30,0)", "seekTo(30,1)"])
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testIntegerLiteralsAndLargeIntegersKeepTheirOriginalRepresentation() {
        let player = CommandCapturingPlayer()
        player.seek(to: 30, allowSeekAhead: false)
        player.seek(to: Int.max, allowSeekAhead: true)
        XCTAssertEqual(player.commands, ["seekTo(30,0)", "seekTo(\(Int.max),1)"])
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testFractionalPositionsReachJavaScriptWithoutTruncation() {
        let player = CommandCapturingPlayer()
        let seconds: Double = 30.5
        player.seek(to: seconds, allowSeekAhead: true)
        let seek: (Double, Bool) -> Void = player.seek(to:allowSeekAhead:)
        seek(seconds, false)
        player.seek(to: 0.125, allowSeekAhead: true)
        XCTAssertEqual(player.commands, ["seekTo(30.5,1)", "seekTo(30.5,0)", "seekTo(0.125,1)"])
    }

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testNonFinitePositionsDoNotProduceInvalidJavaScript() {
        let player = CommandCapturingPlayer()
        for seconds in [Double.nan, Double.infinity, -Double.infinity] {
            player.seek(to: seconds, allowSeekAhead: true)
        }
        XCTAssertTrue(player.commands.isEmpty)
    }
}

private final class CommandCapturingPlayer: YTSwiftyPlayer {
    var commands: [String] = []

    override func evaluatePlayerCommand(_ commandName: String, callbackHandler: ((Any?) -> ())? = nil) {
        commands.append(commandName)
    }
}
