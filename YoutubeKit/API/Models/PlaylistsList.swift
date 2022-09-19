//
//  PlaylistsList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct PlaylistsList: Codable {
    public let etag: String
    public let items: [Playlist]
    public let kind: String
    public let pageInfo: PageInfo
    public let nextPageToken: String?
    public let prevPageToken: String?
}

public struct Playlist: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.PlaylistsList?
    public let status: PlaylistsStatus?
}

public struct PlaylistsStatus: Codable {
    public let privacyStatus: String
}
