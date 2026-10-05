// Exampleの起動テスト。Scene設定から実際に画面が生成されることを検証する。
import XCTest
import UIKit
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
