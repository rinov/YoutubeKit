// パッケージの互換性テスト。既存のリクエストとenumの利用コードを検証する。
import XCTest
@testable import YoutubeKit

final class CompatibilityTests: XCTestCase {
    func testVideoRequestKeepsItsPublicQueryFormat() {
        let videoID = "_6u6UrtXUEI"
        let request = VideoListRequest(part: [.id, .snippet], filter: .id(videoID))
        let urlRequest = request.makeURLRequest()
        let query = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.url?.path, "/youtube/v3/videos")
        XCTAssertEqual(query.first { $0.name == "id" }?.value, videoID)
        XCTAssertEqual(query.first { $0.name == "part" }?.value, "id,snippet")
    }

    func testBundledPlayerAndPrivacyManifestAreAvailable() {
        let bundle = Bundle.yk_frameworkBundle()
        XCTAssertNotNil(bundle.url(forResource: "player", withExtension: "html"))
        XCTAssertNotNil(bundle.url(forResource: "PrivacyInfo", withExtension: "xcprivacy"))
    }

    // 新しいエラー通知を追加しても既存の網羅的switchがコンパイルできることを守る。
    func testLegacyErrorSwitchRemainsExhaustive() {
        func rawCode(_ error: YTSwiftyPlayerError) -> Int {
            switch error {
            case .invalidURLRequest: return 2
            case .html5PlayerError: return 5
            case .videoNotFound: return 100
            case .videoNotPermited: return 101
            case .videoLicenseError: return 150
            }
        }
        XCTAssertEqual(rawCode(.videoNotFound), YTSwiftyPlayerError.videoNotFound.rawValue)
    }
}
