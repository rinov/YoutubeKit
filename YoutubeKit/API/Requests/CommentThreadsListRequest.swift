//
//  CommentThreadsListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/commentThreads/list
public struct CommentThreadsListRequest: Requestable {
    
    public typealias Response = CommentThreadsList
    
    public var path: String {
        return "commentThreads"
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
        q.appendingQueryParameter(key: "moderationStatus", value: moderationStatus)
        q.appendingQueryParameter(key: "order", value: order)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        q.appendingQueryParameter(key: "searchTerms", value: searchTerms)
        q.appendingQueryParameter(key: "textFormat", value: textFormat)
        
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.CommentThreadsList]
    public let filter: Filter.CommentThreadsList
    
    // MARK: - Option parameters
    
    public let maxResults: Int?
    public let moderationStatus: CommentModerationStatus?
    public let order: ResultOrder.CommentThreads?
    public let pageToken: String?
    public let searchTerms: String?
    public let textFormat: CommentTextFormat?
    
    public init(part: [Part.CommentThreadsList],
                filter: Filter.CommentThreadsList,
                maxResults: Int? = nil,
                moderationStatus: CommentModerationStatus? = nil,
                order: ResultOrder.CommentThreads? = nil,
                pageToken: String? = nil,
                searchTerms: String? = nil,
                textFormat: CommentTextFormat? = nil) {
        self.part = part
        self.filter = filter
        self.maxResults = maxResults
        self.moderationStatus = moderationStatus
        self.order = order
        self.pageToken = pageToken
        self.searchTerms = searchTerms
        self.textFormat = textFormat
    }
}

