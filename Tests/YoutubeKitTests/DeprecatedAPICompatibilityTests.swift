// 廃止機能の互換性テスト。警告の追加後も既存の型と生成パラメータを維持する。
import XCTest
@testable import YoutubeKit

final class DeprecatedAPICompatibilityTests: XCTestCase {
    func testLegacyDataRequestsKeepTheirTypesAndParameters() {
        let insert = ActivityInsertRequest(part: [.snippet], description: "legacy", resourceID: nil)
        XCTAssertEqual(insert.path, "activities")
        XCTAssertEqual(insert.httpMethod, .post)
        XCTAssertTrue(insert.isAuthorizedRequest)

        let categories = GuideCategoriesListRequest(part: [.snippet], filter: .regionCode("JP"))
        XCTAssertEqual(categories.path, "guideCategories")
        XCTAssertEqual(categories.queryParameters["regionCode"] as? String, "JP")
        XCTAssertEqual(Filter.ChannelList.categoryID("legacy").keyValue.key, "categoryId")
        XCTAssertEqual(Filter.SearchList.relatedToVideoID("legacy").keyValue.key, "relatedToVideoId")
    }

    func testLegacyEmbedCasesKeepTheirWireValues() {
        XCTAssertEqual(VideoListType.search.rawValue, "search")
        let branding = VideoEmbedParameter.showModestbranding(true).property
        XCTAssertEqual(branding.key, "modestbranding")
        XCTAssertEqual(branding.value as? String, "1")
        let related = VideoEmbedParameter.showRelatedVideo(false).property
        XCTAssertEqual(related.key, "rel")
        XCTAssertEqual(related.value as? String, "0")
    }

    // ケースを削除・追加すると、この既存利用コードがコンパイルできなくなる。
    func testLegacyListTypeSwitchRemainsExhaustive() {
        func name(_ type: VideoListType) -> String {
            switch type {
            case .search: return "search"
            case .userUploads: return "user_uploads"
            case .playlist: return "playlist"
            }
        }
        XCTAssertEqual(name(.playlist), VideoListType.playlist.rawValue)
    }
}
