//
//  CaptionList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

public struct CaptionList: Codable {
    public let etag: String
    public let items: [Caption]
    public let kind: String
}

public struct Caption: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.CaptionList
}
