//
//  GuideCategoriesList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct GuideCategoriesList: Codable {
    public let etag: String
    public let items: [GuideCategory]
    public let kind: String
}

public struct GuideCategory: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.GuideCategoriesList
}
