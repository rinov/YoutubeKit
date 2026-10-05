// 通信の回帰テスト。URLProtocolで分割レスポンスと並行リクエストを再現する。
import XCTest
@testable import YoutubeKit

final class NetworkingTests: XCTestCase {
    private let requestCount = 20
    private let requestTimeout: TimeInterval = 10

    func testConcurrentFirstRequestsDeliverOnceOnRequestedQueue() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ResponseProtocol.self]
        let api = YoutubeAPI(configuration: configuration)
        defer { api.invalidateSession() }
        let completed = expectation(description: "すべてのリクエストが完了する")
        completed.expectedFulfillmentCount = requestCount
        completed.assertForOverFulfill = true
        let callbackQueue = DispatchQueue(label: "YoutubeKitTests.callback")
        let queueKey = DispatchSpecificKey<String>()
        callbackQueue.setSpecific(key: queueKey, value: callbackQueue.label)

        DispatchQueue.concurrentPerform(iterations: requestCount) { index in
            api.send(ProbeRequest(path: String(index)), queue: callbackQueue) { result in
                XCTAssertEqual(DispatchQueue.getSpecific(key: queueKey), callbackQueue.label)
                switch result {
                case .success(let response): XCTAssertEqual(response.value, String(index))
                case .failure(let error): XCTFail("\(error)")
                }
                completed.fulfill()
            }
        }
        wait(for: [completed], timeout: requestTimeout)
    }

    func testHTTPFailureKeepsTheExistingErrorCase() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ResponseProtocol.self]
        let api = YoutubeAPI(configuration: configuration)
        defer { api.invalidateSession() }
        let completed = expectation(description: "HTTPエラーを既存の形式で通知する")
        api.send(ProbeRequest(path: "forbidden")) { result in
            guard case .failure(let error) = result,
                  case ResponseError.unacceptableStatusCode(403) = error else {
                XCTFail("HTTP 403が従来のエラーに変換されていません")
                completed.fulfill()
                return
            }
            completed.fulfill()
        }
        wait(for: [completed], timeout: requestTimeout)
    }

    func testCredentialsCanBeReadWhileOtherThreadsWrite() {
        let originalKey = YoutubeKit.shared.apiKey
        let originalToken = YoutubeKit.shared.accessToken
        defer {
            YoutubeKit.shared.setAPIKey(originalKey)
            YoutubeKit.shared.setAccessToken(originalToken)
        }
        YoutubeKit.shared.setAPIKey("key-initial")
        YoutubeKit.shared.setAccessToken("token-initial")
        DispatchQueue.concurrentPerform(iterations: requestCount) { index in
            YoutubeKit.shared.setAPIKey("key-\(index)")
            YoutubeKit.shared.setAccessToken("token-\(index)")
            XCTAssertTrue(YoutubeKit.shared.apiKey.hasPrefix("key-"))
            XCTAssertTrue(YoutubeKit.shared.accessToken.hasPrefix("token-"))
        }
    }
}

// 既存利用者と同様、Sendableではない参照型のDecodableも受け付ける。
private final class ProbeResponse: Decodable {
    let value: String
}

private struct ProbeRequest: Requestable {
    typealias Response = ProbeResponse
    let path: String
    var baseURL: URL { URL(string: "https://youtubekit.invalid/")! }
    var httpMethod: HTTPMethod { .get }
}

private final class ResponseProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let url = request.url!
        let value = url.lastPathComponent
        let statusCode = value == "forbidden" ? 403 : 200
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        let data = try! JSONSerialization.data(withJSONObject: ["value": value])
        let split = data.count / 2
        client?.urlProtocol(self, didLoad: data.prefix(split))
        client?.urlProtocol(self, didLoad: data.suffix(from: split))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
