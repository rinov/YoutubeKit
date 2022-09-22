//
//  Snippet.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// MARK: - Namespace
public enum Snippet {}

extension Snippet {
    public struct VideoList: Codable {
        public let description: String
        public let channelID: String
        public let categoryID: String
        public let channelTitle: String
        public let localized: Localized
        public let tags: [String]?
        public let liveBroadcastContent: String
        public let publishedAt: String
        public let thumbnails: Thumbnails.VideoList
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case description
            case channelID = "channelId"
            case categoryID = "categoryId"
            case channelTitle
            case localized
            case tags
            case liveBroadcastContent
            case publishedAt
            case thumbnails
            case title
        }
    }
}

extension Snippet {
    public struct ActivityList: Codable {
        public let publishedAt: String
        public let channelTitle: String
        public let channelID: String
        public let description: String
        public let title: String?
        public let thumbnails: Thumbnails.ActivityList
        public let type: String
        
        public enum CodingKeys: String, CodingKey {
            case publishedAt
            case channelTitle
            case channelID = "channelId"
            case description
            case title
            case thumbnails
            case type
        }
    }
}

extension Snippet {
    public struct CaptionList: Codable {
        public let audioTrackType: String
        public let isAutoSynced: Bool
        public let isCC: Bool
        public let isDraft: Bool
        public let isEasyReader: Bool
        public let isLarge: Bool
        public let language: String
        public let lastUpdated: String
        public let name: String
        public let status: String
        public let trackKind: String
        public let videoID: String
        
        public enum CodingKeys: String, CodingKey {
            case audioTrackType
            case isAutoSynced
            case isCC
            case isDraft
            case isEasyReader
            case isLarge
            case language
            case lastUpdated
            case name
            case status
            case trackKind
            case videoID = "videoId"
        }
    }
}

extension Snippet {
    public struct ChannelList: Codable {
        public let customURL: String?
        public let description: String
        public let localized: Localized
        public let publishedAt: String
        public let thumbnails: Thumbnails.ChannelList
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case customURL = "customUrl"
            case description
            case localized
            case publishedAt
            case thumbnails
            case title
        }
    }
}

extension Snippet {
    public struct ChannelSectionsList: Codable {
        public let channelID: String
        public let position: Int
        public let style: String
        public let type: String
        
        public enum CodingKeys: String, CodingKey {
            case channelID = "channelId"
            case position
            case style
            case type
        }
    }
}

extension Snippet {
    public struct I18nLanguagesList: Codable {
        public let hl: String
        public let name: String
    }
}

extension Snippet {
    public struct I18nRegionsList: Codable {
        public let gl: String
        public let name: String
    }
}

extension Snippet {
    public struct VideoCategoriesList: Codable {
        public let assignable: Bool
        public let channelID: String
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case assignable
            case channelID = "channelId"
            case title
        }
    }
}

extension Snippet {
    public struct SearchList: Codable {
        public let channelID: String
        public let channelTitle: String
        public let description: String
        public let liveBroadcastContent: String
        public let publishedAt: String
        public let thumbnails: Thumbnails.SearchList
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case channelID = "channelId"
            case channelTitle
            case description
            case liveBroadcastContent
            case publishedAt
            case thumbnails
            case title
        }
    }
}

extension Snippet {
    public struct GuideCategoriesList: Codable {
        public let channelID: String
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case channelID = "channelId"
            case title
        }
    }
}

extension Snippet {
    public struct SubscriptionsList: Codable {
        public let channelID: String
        public let description: String
        public let publishedAt: String
        public let resourceID: ResourceID.SubscriptionsList
        public let thumbnails: Thumbnails.Default
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case channelID = "channelId"
            case description
            case publishedAt
            case resourceID = "resourceId"
            case thumbnails
            case title
        }
    }
}

extension Snippet {
    public struct VideoAbuseReportReasonsList: Codable {
        public let label: String
        public let secondaryReasons: [SecondaryReason]
    }
}

extension Snippet {
    public struct PlaylistsList: Codable {
        public let channelID: String
        public let channelTitle: String
        public let description: String
        public let localized: Localized
        public let publishedAt: String
        public let thumbnails: Thumbnails.PlaylistsList
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case channelID = "channelId"
            case channelTitle
            case description
            case localized
            case publishedAt
            case thumbnails
            case title
        }
    }
}

extension Snippet {
    public struct PlaylistItemsList: Codable {
        public let channelID: String
        public let channelTitle: String
        public let description: String
        public let playlistID: String
        public let position: Int
        public let publishedAt: String
        public let resourceID: ResourceID.PlaylistItemsList
        public let thumbnails: Thumbnails.PlaylistItemsList?
        public let title: String
        
        public enum CodingKeys: String, CodingKey {
            case channelID = "channelId"
            case channelTitle
            case description
            case playlistID = "playlistId"
            case position
            case publishedAt
            case resourceID = "resourceId"
            case thumbnails
            case title
        }
    }
}

extension Snippet {
    public struct CommentInfo: Codable {
        public let canReply: Bool
        public let isPublic: Bool
        public let topLevelComment: Snippet.TopLevelComment
        public let totalReplyCount: Int
        public let videoID: String
        
        public enum CodingKeys: String, CodingKey {
            case canReply
            case isPublic
            case topLevelComment
            case totalReplyCount
            case videoID = "videoId"
        }
    }
}

extension Snippet {
    public struct TopLevelComment: Codable {
        public let etag: String
        public let id: String
        public let kind: String
        public let snippet: Snippet.Comment
    }
}

extension Snippet {
    public struct Comment: Codable {
        public let authorChannelID: AuthorChannelID
        public let authorChannelURL: String
        public let authorDisplayName: String
        public let authorProfileImageURL: String
        public let canRate: Bool
        public let likeCount: Int
        public let parentID: String?
        public let publishedAt: String
        public let textDisplay: String
        public let textOriginal: String
        public let updatedAt: String
        public let videoID: String?
        public let viewerRating: String
        
        public enum CodingKeys: String, CodingKey {
            case authorChannelID = "authorChannelId"
            case authorChannelURL = "authorChannelUrl"
            case authorDisplayName
            case authorProfileImageURL = "authorProfileImageUrl"
            case canRate
            case likeCount
            case parentID = "parentId"
            case publishedAt
            case textDisplay
            case textOriginal
            case updatedAt
            case videoID = "videoId"
            case viewerRating
        }
    }
}
