//
//  ChannelList.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct ChannelList: Codable {
    public let etag: String
    public let items: [Channel]
    public let kind: String
    public let pageInfo: PageInfo
    public let nextPageToken: String?
    public let prevPageToken: String?
}

public struct Channel: Codable {
    public let brandingSettings: BrandingSettings?
    public let contentDetails: ContentDetails.ChannelList?
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.ChannelList?
    public let statistics: Statistics.ChannelList?
    public let topicDetails: TopicDetails?
}

public struct TopicDetails: Codable {
    public let topicCategories: [String]?
    public let topicIDs: [String]?
    
    public enum CodingKeys: String, CodingKey {
        case topicCategories = "topicCategories"
        case topicIDs = "topicIds"
    }
}

public struct RelatedPlaylists: Codable {
    public let uploads: String?
    public let watchHistory: String?
    public let watchLater: String?
}

public struct BrandingSettings: Codable {
    public let channelMetadata: ChannelMetadata
    public let hints: [Hint]?
    public let image: Image?
    
    public enum CodingKeys: String, CodingKey {
        case channelMetadata = "channel"
        case hints,image
    }
}

public struct Image: Codable {
    public let bannerImageURL: String?
    public let bannerMobileExtraHdImageURL: String?
    public let bannerMobileHdImageURL: String?
    public let bannerMobileImageURL: String?
    public let bannerMobileLowImageURL: String?
    public let bannerMobileMediumHdImageURL: String?
    public let bannerTabletExtraHdImageURL: String?
    public let bannerTabletHdImageURL: String?
    public let bannerTabletImageURL: String?
    public let bannerTabletLowImageURL: String?
    public let bannerTvHighImageURL: String?
    public let bannerTvImageURL: String?
    public let bannerTvLowImageURL: String?
    public let bannerTvMediumImageURL: String?
    
    public enum CodingKeys: String, CodingKey {
        case bannerImageURL = "bannerImageUrl"
        case bannerMobileExtraHdImageURL = "bannerMobileExtraHdImageUrl"
        case bannerMobileHdImageURL = "bannerMobileHdImageUrl"
        case bannerMobileImageURL = "bannerMobileImageUrl"
        case bannerMobileLowImageURL = "bannerMobileLowImageUrl"
        case bannerMobileMediumHdImageURL = "bannerMobileMediumHdImageUrl"
        case bannerTabletExtraHdImageURL = "bannerTabletExtraHdImageUrl"
        case bannerTabletHdImageURL = "bannerTabletHdImageUrl"
        case bannerTabletImageURL = "bannerTabletImageUrl"
        case bannerTabletLowImageURL = "bannerTabletLowImageUrl"
        case bannerTvHighImageURL = "bannerTvHighImageUrl"
        case bannerTvImageURL = "bannerTvImageUrl"
        case bannerTvLowImageURL = "bannerTvLowImageUrl"
        case bannerTvMediumImageURL = "bannerTvMediumImageUrl"
    }
}

public struct Hint: Codable {
    public let property: String?
    public let value: String?
}

public struct ChannelMetadata: Codable {
    public let defaultTab: String?
    public let description: String?
    public let featuredChannelsTitle: String?
    public let featuredChannelsURLs: [String]?
    public let keywords: String?
    public let profileColor: String?
    public let showBrowseView: Bool?
    public let showRelatedChannels: Bool?
    public let title: String?
    public let unsubscribedTrailer: String?
    
    public enum CodingKeys: String, CodingKey {
        case defaultTab
        case description
        case featuredChannelsTitle
        case featuredChannelsURLs = "featuredChannelsUrls"
        case keywords
        case profileColor
        case showBrowseView
        case showRelatedChannels
        case title
        case unsubscribedTrailer
    }
}
