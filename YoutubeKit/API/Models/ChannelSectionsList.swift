//
//  ChannelSections.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct ChannelSectionsList: Codable {
    public let etag: String
    public let items: [ChannelSection]
    public let kind: String
}

public struct ChannelSection: Codable {
    public let contentDetails: ContentDetails.ChannelSectionsList?
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.ChannelSectionsList
}
