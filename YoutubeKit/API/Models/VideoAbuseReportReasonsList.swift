//
//  VideoAbuseReportReasonsList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct VideoAbuseReportReasonsList: Codable {
    public let etag: String
    public let items: [VideoAbuseReportReason]
    public let kind: String
}

public struct VideoAbuseReportReason: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.VideoAbuseReportReasonsList
}

public struct SecondaryReason: Codable {
    public let id: String
    public let label: String
}
