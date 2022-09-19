//
//  CommentListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// To parse the JSON, add this file to your project and do:
//
//   let commentList = CommentList.from(json: jsonString)!

import Foundation

public struct CommentList: Codable {
    public let etag: String
    public let items: [Comment]
    public let kind: String
    public let pageInfo: PageInfo?
    public let nextPageToken: String?
}
