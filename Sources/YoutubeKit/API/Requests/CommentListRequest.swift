//
//  CommentListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/comments/list
public struct CommentListRequest: Requestable {
    
    public typealias Response = CommentList
    
    public var path: String {
        return "comments"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)
        
        let filterParam = filter.keyValue
        q[filterParam.key] = filterParam.value
        
        q.appendingQueryParameter(key: "maxResults", value: maxResults)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        q.appendingQueryParameter(key: "textFormat", value: textFormat)
        
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.CommentThreadsList]
    public let filter: Filter.CommentThreadsList
    
    // MARK: - Option parameters
    
    public let maxResults: Int?
    public let pageToken: String?
    public let textFormat: CommentTextFormat?
    
    public init(part: [Part.CommentThreadsList],
                filter: Filter.CommentThreadsList,
                maxResults: Int? = nil,
                pageToken: String? = nil,
                textFormat: CommentTextFormat? = nil) {
        self.part = part
        self.filter = filter
        self.maxResults = maxResults
        self.pageToken = pageToken
        self.textFormat = textFormat
    }
}
