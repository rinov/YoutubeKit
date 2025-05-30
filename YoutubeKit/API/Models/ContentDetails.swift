//
//  ContentDetails.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// MARK: - Namespace
public enum ContentDetails {}

extension ContentDetails {
    public struct VideoList: Codable {
        public let definition: String
        public let duration: String
        public let caption: String
        public let dimension: String
        public let licensedContent: Bool
        public let projection: String
    }
}

extension ContentDetails {
    public struct ActivityList: Codable {
        public let upload: Upload?
    }
}

extension ContentDetails {
    public struct ChannelList: Codable {
        public let relatedPlaylists: RelatedPlaylists
    }
}

extension ContentDetails {
    public struct ChannelSectionsList: Codable {
        public let playlists: [String]
    }
}

extension ContentDetails {
    public struct SubscriptionsList: Codable {
        public let activityType: String
        public let newItemCount: Int
        public let totalItemCount: Int
    }
}

extension ContentDetails {
    public struct PlaylistsList: Codable {
        public let itemCount: Int
    }
}

extension ContentDetails {
    public struct PlaylistItemsList: Codable {
        public let videoID: String
        /* Whereas the documentation seems indicating that this property is non-optional, the reality is different.
         * In some cases this property may not be returned by the API, at least in the following case :
         *   If a playlist contains a video which is now private and not owned by the owner of the access token. */
        public let videoPublishedAt: String?

        public enum CodingKeys: String, CodingKey {
            case videoID = "videoId"
            case videoPublishedAt = "videoPublishedAt"
        }
    }
}
