//
//  ResourceID.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// MARK: - Namespace
public enum ResourceID {}

extension ResourceID {
    public struct ActivityInsert {
        public let kind: String?
        public let channelID: String?
        public let playlistID: String?
        public let videoID: String?
        
        public init(kind: String? = nil,
                    channelID: String? = nil,
                    playlistID: String? = nil,
                    videoID: String? = nil) {
            self.kind = kind
            self.channelID = channelID
            self.playlistID = playlistID
            self.videoID = videoID
        }
    }
}

extension ResourceID {
    public struct SubscriptionsList: Codable {
        public let channelID: String
        public let kind: String
        
        public enum CodingKeys: String, CodingKey {
            case channelID = "channelId"
            case kind = "kind"
        }
    }
}

extension ResourceID {
    public struct PlaylistItemsList: Codable {
        public let kind: String
        public let videoID: String
        
        public enum CodingKeys: String, CodingKey {
            case kind = "kind"
            case videoID = "videoId"
        }
    }
}
