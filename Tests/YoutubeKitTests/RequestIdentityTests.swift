// Data API request identity tests protect restricted keys and existing authentication behavior.
import XCTest
@testable import YoutubeKit

final class RequestIdentityTests: XCTestCase {
    private let identityHeader = "X-Ios-Bundle-Identifier"
    private let bundleIdentifier = "jp.Example.YoutubeApp"

    func testAPIKeyRequestIncludesTheExactBundleIdentifier() {
        let request = SearchListRequest(part: [.snippet], searchQuery: "music")
            .makeURLRequest(bundleIdentifier: bundleIdentifier)
        XCTAssertEqual(request.value(forHTTPHeaderField: identityHeader), bundleIdentifier)
        XCTAssertEqual(queryValue("key", in: request), YoutubeKit.shared.apiKey)
        XCTAssertEqual(queryValue("q", in: request), "music")
        XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
    }

    func testPublicRequestBuilderUsesTheHostBundle() {
        let request = SearchListRequest(part: [.id]).makeURLRequest()
        let identifier = Bundle.main.bundleIdentifier
        XCTAssertEqual(request.value(forHTTPHeaderField: identityHeader),
                       identifier?.isEmpty == false ? identifier : nil)
    }

    func testExplicitIdentityIsPreservedRegardlessOfHeaderCasing() {
        for name in [identityHeader, identityHeader.lowercased(), identityHeader.uppercased()] {
            let explicitIdentifier = "org.Custom.Client"
            let request = IdentityRequest(headerField: [name: explicitIdentifier])
                .makeURLRequest(bundleIdentifier: bundleIdentifier)
            XCTAssertEqual(request.value(forHTTPHeaderField: identityHeader), explicitIdentifier)
            XCTAssertEqual(request.allHTTPHeaderFields?.keys.filter {
                $0.caseInsensitiveCompare(identityHeader) == .orderedSame
            }.count, 1)
        }
    }

    func testExplicitEmptyIdentityIsNotReplaced() {
        let request = IdentityRequest(headerField: [identityHeader: ""])
            .makeURLRequest(bundleIdentifier: bundleIdentifier)
        XCTAssertEqual(request.value(forHTTPHeaderField: identityHeader), "")
    }

    func testMissingBundleIdentifierDoesNotAddAnEmptyHeader() {
        let identifiers: [String?] = [nil, ""]
        for identifier in identifiers {
            let request = IdentityRequest().makeURLRequest(bundleIdentifier: identifier)
            XCTAssertNil(request.value(forHTTPHeaderField: identityHeader))
            XCTAssertNotNil(queryValue("key", in: request))
        }
    }

    func testOAuthRequestKeepsBearerAuthenticationWithoutAPIKeyIdentity() {
        let request = IdentityRequest(isAuthorizedRequest: true)
            .makeURLRequest(bundleIdentifier: bundleIdentifier)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"),
                       "Bearer \(YoutubeKit.shared.accessToken)")
        XCTAssertNil(request.value(forHTTPHeaderField: identityHeader))
        XCTAssertNil(queryValue("key", in: request))
    }

    func testOAuthRequestPreservesExplicitAuthenticationAndIdentity() {
        let headers = ["Authorization": "Bearer custom-token", identityHeader: "org.Custom.OAuth"]
        let request = IdentityRequest(headerField: headers, isAuthorizedRequest: true)
            .makeURLRequest(bundleIdentifier: bundleIdentifier)
        for (name, value) in headers {
            XCTAssertEqual(request.value(forHTTPHeaderField: name), value)
        }
        XCTAssertNil(queryValue("key", in: request))
    }

    func testIdentityDoesNotReplaceCustomHeadersOrRequestBody() {
        let body = Data("payload".utf8)
        let request = IdentityRequest(headerField: ["Content-Type": "application/json"], httpBody: body)
            .makeURLRequest(bundleIdentifier: bundleIdentifier)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.httpBody, body)
        XCTAssertEqual(request.httpMethod, "POST")
    }

    private func queryValue(_ name: String, in request: URLRequest) -> String? {
        return URLComponents(url: request.url!, resolvingAgainstBaseURL: false)?
            .queryItems?.first { $0.name == name }?.value
    }
}

private struct IdentityRequest: Requestable {
    typealias Response = VideoList
    var headerField: [String: String] = [:]
    var isAuthorizedRequest = false
    var httpBody: Data? = nil
    var path: String { "videos" }
    var httpMethod: HTTPMethod { .post }
}
