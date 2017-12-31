//
//  VideoListModel.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct VideoList: Codable {
    public let items: [Video]
    public let etag: String
    public let kind: String
    public let pageInfo: PageInfo
    public let nextPageToken: String?
    public let prevPageToken: String?
}

public struct Video: Codable {
    public let etag: String
    public let kind: String
    public let id: String
    public let contentDetails: ContentDetails.VideoList?
    public let statistics: Statistics.VideoList?
    public let snippet: Snippet.VideoList?
    public let status: Status?
}

public struct Status: Codable {
    public let license: String
    public let publicStatsViewable: Bool
    public let embeddable: Bool
    public let privacyStatus: String
    public let uploadStatus: String
}
