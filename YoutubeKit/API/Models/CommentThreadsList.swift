//
//  CommentThreadsList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct CommentThreadsList: Codable {
    public let etag: String
    public let items: [CommentThread]
    public let kind: String
    public let nextPageToken: String?
    public let pageInfo: PageInfo
}

public struct CommentThread: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let replies: CommentReplies?
    public let snippet: Snippet.CommentInfo
}

public struct CommentReplies: Codable {
    public let comments: [Comment]
}

public struct Comment: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.Comment
}

public struct AuthorChannelID: Codable {
    public let value: String
}
