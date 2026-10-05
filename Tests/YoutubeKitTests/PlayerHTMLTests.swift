// 同梱HTMLの転送テスト。YouTubeへ接続せずJavaScript自体の通知経路を検証する。
import XCTest
import JavaScriptCore
@testable import YoutubeKit

final class PlayerHTMLTests: XCTestCase {
    func testBundledHTMLForwardsErrorAndAutoplayEvents() throws {
        let url = try XCTUnwrap(Bundle.yk_frameworkBundle().url(forResource: "player", withExtension: "html"))
        let html = try String(contentsOf: url, encoding: .utf8)
        let script = try XCTUnwrap(html.components(separatedBy: "<script>").last?
            .components(separatedBy: "</script>").first)
            .replacingOccurrences(of: "%@", with: "{}")
        let context = try XCTUnwrap(JSContext())
        context.evaluateScript("""
            var recorded = [];
            var YT = {ready: function() {}};
            var webkit = {messageHandlers: {
                onError: {postMessage: function(code) {recorded.push(['error', code]);}},
                onAutoplayBlocked: {postMessage: function() {recorded.push(['autoplay']);}}
            }};
            """)
        context.evaluateScript(script)
        XCTAssertNil(context.exception)
        let output = context.evaluateScript("onError({data:153}); onAutoplayBlocked({}); JSON.stringify(recorded);")
        XCTAssertNil(context.exception)
        XCTAssertEqual(output?.toString(), "[[\"error\",153],[\"autoplay\"]]")
    }
}
