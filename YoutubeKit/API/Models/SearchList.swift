//
//  SearchList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct SearchList: Codable {
    public let etag: String
    public let items: [SearchResult]
    public let kind: String
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let pageInfo: PageInfo
    public let regionCode: String
}

public struct SearchResult: Codable {
    public let etag: String
    public let id: SearchResultID
    public let kind: String
    public let snippet: Snippet.SearchList
}

public struct SearchResultID: Codable {
    public let channelID: String?
    public let kind: String
    public let videoID: String?
    
    public enum CodingKeys: String, CodingKey {
        case channelID = "channelId"
        case kind
        case videoID = "videoId"
    }
}
