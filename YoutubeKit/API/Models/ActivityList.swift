//
//  ActivityList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

public struct ActivityList: Codable {
    public let items: [Activity]
    public let nextPageToken: String?
    public let etag: String
    public let kind: String
    public let pageInfo: PageInfo
    
    public init(items: [Activity],
                nextPageToken: String,
                etag: String,
                kind: String,
                pageInfo: PageInfo) {
        self.items = items
        self.nextPageToken = nextPageToken
        self.etag = etag
        self.kind = kind
        self.pageInfo = pageInfo
    }
}

public struct Activity: Codable {
    public let etag: String
    public let kind: String
    public let contentDetails: ContentDetails.ActivityList?
    public let id: String
    public let snippet: Snippet.ActivityList?
}

public struct Upload: Codable {
    public let videoID: String
    
    public enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
    }
}
