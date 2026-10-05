//
//  RequestableExtensions.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//  Builds Data API requests while preserving caller-supplied authentication headers.
//

import Foundation

extension Requestable {
    
    public var baseURL: URL {
        return URL(string: "https://www.googleapis.com/youtube/\(YoutubeKit.youtubeDataAPIVersion)/")!
    }
    
    public var queryParameters: [String: Any] {
        return [:]
    }
    
    public var headerField: [String: String] {
        var header: [String: String] = [:]
        if isAuthorizedRequest {
            header["Authorization"] = "Bearer \(YoutubeKit.shared.accessToken)"
        }
        return header
    }
    
    public var isAuthorizedRequest: Bool {
        return false
    }
    
    public var httpBody: Data? {
        return nil
    }

    public func makeURLRequest() -> URLRequest {
        return makeURLRequest(bundleIdentifier: Bundle.main.bundleIdentifier)
    }

    // Keep identity injectable internally so missing app bundles can be tested without global state.
    internal func makeURLRequest(bundleIdentifier: String?) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue

        // Setup header
        var header: [String: String] = headerField
        if isAuthorizedRequest && !header.contains(where: { $0.key == "Authorization" }) {
            header["Authorization"] = "Bearer \(YoutubeKit.shared.accessToken)"
        }
        // Google requires the exact app ID for iOS-restricted API keys. HTTP header names
        // are case-insensitive; an explicit caller value (including an empty one) wins.
        let identityHeader = "X-Ios-Bundle-Identifier"
        if !isAuthorizedRequest,
           !header.keys.contains(where: { $0.caseInsensitiveCompare(identityHeader) == .orderedSame }),
           let identifier = bundleIdentifier, !identifier.isEmpty {
            header[identityHeader] = identifier
        }
        header.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        // Setup body
        if let body = httpBody {
            urlRequest.httpBody = body
        }
        
        // Setup query parameters
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return urlRequest }
        var keyParams: [String: Any] = queryParameters
        if !isAuthorizedRequest {
            keyParams["key"] = YoutubeKit.shared.apiKey
        }
        urlComponents.queryItems = keyParams.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        
        // Setup complete URL
        urlRequest.url = urlComponents.url
        
        return urlRequest
    }
}
