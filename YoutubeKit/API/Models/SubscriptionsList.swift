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
}

public struct Subscription: Codable {
    public let contentDetails: ContentDetails.SubscriptionsList?
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.SubscriptionsList?
}
