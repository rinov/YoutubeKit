// Hosted UI tests for the example scene and the bundled player viewport.
import XCTest
import UIKit
import WebKit
import YoutubeKit
@testable import YoutubeKit_Example

final class SceneLifecycleTests: XCTestCase {
    private let startupTimeout: TimeInterval = 5

    func testSceneCreatesTheStoryboardWindow() {
        let ready = expectation(description: "SceneにExampleの画面が接続される")
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            let windows = scenes.flatMap { $0.windows }
            XCTAssertTrue(scenes.contains { $0.delegate is SceneDelegate })
            XCTAssertTrue(windows.contains { $0.rootViewController is ViewController })
            ready.fulfill()
        }
        wait(for: [ready], timeout: startupTimeout)
    }
}

// WebKit rendering requires the application host supplied by this test target.
final class PlayerViewportTests: XCTestCase {
    private let navigationTimeout: TimeInterval = 10
    private let layoutTolerance: Double = 1
    private let portraitSize = CGSize(width: 390, height: 844)

    #if compiler(>=5.5)
    @MainActor
    #endif
    func testViewportFitsPortraitAndLandscapeViewSizes() throws {
        let loader = HTMLCapturingPlayer()
        loader.loadDefaultPlayer()
        let html = try XCTUnwrap(loader.loadedHTML)
        // Keep the shipped layout and viewport, removing only network and player scripts.
        let layoutHTML = html.replacingOccurrences(of: "(?s)<script\\b[^>]*>.*?</script>",
                                                   with: "", options: .regularExpression)
        let player = YTSwiftyPlayer(frame: CGRect(origin: .zero, size: portraitSize))
        let landscapeSize = CGSize(width: portraitSize.height, height: portraitSize.width)
        for size in [portraitSize, landscapeSize] {
            player.frame = CGRect(origin: .zero, size: size)
            let ready = expectation(description: "Viewport matches \(size)")
            let expectedWidth = Double(size.width)
            let tolerance = layoutTolerance
            let observer = NavigationObserver {
                player.evaluateJavaScript("[window.innerWidth, document.documentElement.clientWidth]") { result, error in
                    XCTAssertNil(error)
                    let widths = result as? [Double]
                    XCTAssertEqual(widths?.count, 2)
                    for width in widths ?? [] {
                        XCTAssertEqual(width, expectedWidth, accuracy: tolerance)
                    }
                    ready.fulfill()
                }
            }
            player.navigationDelegate = observer
            player.loadHTMLString(layoutHTML, baseURL: nil)
            waitForExpectations(timeout: navigationTimeout)
            // WKWebView's navigationDelegate is weak; retain it until the assertions run.
            withExtendedLifetime(observer) {}
        }
    }
}

#if compiler(>=5.5)
@MainActor
#endif
private final class NavigationObserver: NSObject, WKNavigationDelegate {
    private let didLoad: () -> Void

    init(didLoad: @escaping () -> Void) {
        self.didLoad = didLoad
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didLoad()
    }
}

// Use the public loader to inspect the exact packaged HTML without starting YouTube.
private final class HTMLCapturingPlayer: YTSwiftyPlayer {
    var loadedHTML: String?

    override func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        loadedHTML = string
        return nil
    }
}
