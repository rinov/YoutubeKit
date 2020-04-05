//
//  VideoCategoryList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct VideoCategoriesList: Codable {
    public let etag: String
    public let items: [VideoCategory]
    public let kind: String
}

public struct VideoCategory: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.VideoCategoriesList
}
