//
//  I18nRegions.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct I18nRegionsList: Codable {
    public let etag: String
    public let items: [I18nRegion]
    public let kind: String
}

public struct I18nRegion: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.I18nRegionsList
}
