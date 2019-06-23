//
//  SubscriptionsList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct SubscriptionsList: Codable {
    public let etag: String
    public let items: [Subscription]
    public let kind: String
    public let pageInfo: PageInfo
    public let nextPageToken: String?
    public let prevPageToken: String?
    
    public init(etag: String, items: [Subscription], kind: String, pageInfo: PageInfo, nextPageToken: String? = nil, prevPageToken: String? = nil) {
        self.etag = etag
        self.items = items
        self.kind = kind
        self.pageInfo = pageInfo
        self.nextPageToken = nextPageToken
        self.prevPageToken = prevPageToken
    }
}

public struct Subscription: Codable {
    public let contentDetails: ContentDetails.SubscriptionsList?
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.SubscriptionsList?
}
