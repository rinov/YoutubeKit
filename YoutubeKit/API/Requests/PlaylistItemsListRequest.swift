//
//  PlaylistItemsListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/playlistItems/list
public struct PlaylistItemsListRequest: Requestable {
    
    public typealias Response = PlaylistItemsList
    
    public var path: String {
        return "playlistItems"
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
        q.appendingQueryParameter(key: "videoID", value: videoID)
        
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.PlaylistItemsList]
    public let filter: Filter.PlaylistItemsList
    
    // MARK: - Option parameters
    
    public let maxResults: Int?
    public let pageToken: String?
    public let videoID: String?
    
    public init(part: [Part.PlaylistItemsList],
                filter: Filter.PlaylistItemsList,
                maxResults: Int? = nil,
                pageToken: String? = nil,
                videoID: String? = nil) {
        self.part = part
        self.filter = filter
        self.maxResults = maxResults
        self.pageToken = pageToken
        self.videoID = videoID
    }
}
