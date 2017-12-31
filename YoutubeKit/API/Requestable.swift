//
//  Requestable.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public protocol Requestable {
    
    // The response of `Requestable` expects JSON object.
    associatedtype Response: Decodable
    
    // The base of URL.
    var baseURL: URL { get }
    
    // The path of URL.
    var path: String { get }
    
    // The header field of HTTP.
    var headerField: [String: String] { get }
    
    // If the request needs OAuth authorization, this will set `true`. The default value is `false`.
    var isAuthorizedRequest: Bool { get }
    
    // Set http method. Example: `.get`
    var httpMethod: HTTPMethod { get }
    
    // The http body parameter, The default value is `nil`.
    var httpBody: Data? { get }
    
    // Additional query paramters for URL, The default value is `[:]`.
    var queryParameters: [String: Any] { get }
}
