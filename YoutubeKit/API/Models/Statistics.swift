//
//  Statistics.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

// MARK: - Namespace
public enum Statistics {}

extension Statistics {
    public struct VideoList: Codable {
        public let dislikeCount: String?
        public let likeCount: String
        public let commentCount: String?
        public let favoriteCount: String
        public let viewCount: String
    }
}

extension Statistics {
    public struct ChannelList: Codable {
        public let commentCount: String?
        public let hiddenSubscriberCount: Bool?
        public let subscriberCount: String?
        public let videoCount: String
        public let viewCount: String
    }
}
