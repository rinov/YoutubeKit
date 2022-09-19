//
//  SubscriptionsList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct SubsucriptionsList: Codable {
    public let etag: String
    public let items: [Subsucription]
    public let kind: String
    public let pageInfo: PageInfo
}

public struct Subsucription: Codable {
    public let contentDetails: ContentDetails.SubscriptionsList
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.SubscriptionsList
}
