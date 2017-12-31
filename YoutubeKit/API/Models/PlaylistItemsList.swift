//
//  PlaylistItemsList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct PlaylistItemsList: Codable {
    public let etag: String
    public let items: [PlaylistItem]
    public let kind: String
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let pageInfo: PageInfo
}

public struct PlaylistItem: Codable {
    public let contentDetails: ContentDetails.PlaylistItemsList
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.PlaylistItemsList
    public let status: PlaylistItemsStatus
}

public struct PlaylistItemsStatus: Codable {
    public let privacyStatus: String
}
