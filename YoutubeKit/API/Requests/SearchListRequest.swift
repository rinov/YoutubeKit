//
//  SearchListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/search/list
public struct SearchListRequest: Requestable {
    
    public typealias Response = SearchList
    
    public var path: String {
        return "search"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var isAuthorizedRequest: Bool {
        switch filter {
        case .forContentOwner(_)?:
            return true
        case .forMine(_)?:
            return true
        case .relatedToVideoID(_)?:
            return false
        case .none:
            return false
        }
    }
    
    public var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)

        if let filterParam = filter?.keyValue {
            q[filterParam.key] = filterParam.value
        }
        
        q.appendingQueryParameter(key: "channelId", value: channelID)
        q.appendingQueryParameter(key: "q", value: searchQuery)
        q.appendingQueryParameter(key: "topicId", value: topicID)
        q.appendingQueryParameter(key: "type", value: resourceType)
        q.appendingQueryParameter(key: "videoCategoryId", value: videoCategoryID)
        q.appendingQueryParameter(key: "channelType", value: channelType)
        q.appendingQueryParameter(key: "eventType", value: eventType)
        q.appendingQueryParameter(key: "maxResults", value: maxResults)
        q.appendingQueryParameter(key: "onBehalfOfContentOwner", value: onBehalfOfContentOwner)
        q.appendingQueryParameter(key: "order", value: order)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        q.appendingQueryParameter(key: "publishedAfter", value: publishedAfter)
        q.appendingQueryParameter(key: "publishedBefore", value: publishedBefore)
        q.appendingQueryParameter(key: "regionCode", value: regionCode)
        q.appendingQueryParameter(key: "safeSearch", value: safeSearch)
        q.appendingQueryParameter(key: "videoCaption", value: videoCaption)
        q.appendingQueryParameter(key: "videoDefinition", value: videoDefinition)
        q.appendingQueryParameter(key: "videoDimension", value: videoDimension)
        q.appendingQueryParameter(key: "videoDuration", value: videoDuration)
        q.appendingQueryParameter(key: "videoEmbeddable", value: videoEmbeddable)
        q.appendingQueryParameter(key: "videoLicense", value: videoLicense)
        q.appendingQueryParameter(key: "videoSyndicated", value: videoSyndicated)
        q.appendingQueryParameter(key: "videoType", value: videoType)
        
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.SearchList]
    
    // MARK: - Option parameters
    
    public let filter: Filter.SearchList?
    public let channelID: String?
    public let channelType: String?
    public let eventType: SearchEventType?
    public let maxResults: Int?
    public let onBehalfOfContentOwner: String?
    public let order: ResultOrder.Search?
    public let pageToken: String?
    public let publishedAfter: Date?
    public let publishedBefore: Date?
    public let searchQuery: String?
    public let regionCode: String?
    public let safeSearch: SearchSafeMode?
    public let topicID: String?
    public let resourceType: [SearchResourceType]?
    public let videoCaption: SearchVideoCaption?
    public let videoCategoryID: VideoCategoryID?
    public let videoDefinition: SearchVideoDefinition?
    public let videoDimension: SearchVideoDimension?
    public let videoDuration: SearchVideoDuration?
    public let videoEmbeddable: SearchVideoEmbeddable?
    public let videoLicense: SearchVideoLicense?
    public let videoSyndicated: SearchVideoSyndicated?
    public let videoType: SearchVideoType?
    
    public init(part: [Part.SearchList],
                filter: Filter.SearchList? = nil,
                channelID: String? = nil,
                channelType: String? = nil,
                eventType: SearchEventType? = nil,
                maxResults: Int? = nil,
                onBehalfOfContentOwner: String? = nil,
                order: ResultOrder.Search? = nil,
                pageToken: String? = nil,
                publishedAfter: Date? = nil,
                publishedBefore: Date? = nil,
                searchQuery: String? = nil,
                regionCode: String? = nil,
                safeSearch: SearchSafeMode? = nil,
                topicID: String? = nil,
                resourceType: [SearchResourceType]? = nil,
                videoCaption: SearchVideoCaption? = nil,
                videoCategoryID: VideoCategoryID? = nil,
                videoDefinition: SearchVideoDefinition? = nil,
                videoDimension: SearchVideoDimension? = nil,
                videoDuration: SearchVideoDuration? = nil,
                videoEmbeddable: SearchVideoEmbeddable? = nil,
                videoLicense: SearchVideoLicense? = nil,
                videoSyndicated: SearchVideoSyndicated? = nil,
                videoType: SearchVideoType? = nil) {
        self.part = part
        self.filter = filter
        self.channelID = channelID
        self.channelType = channelType
        self.eventType = eventType
        self.maxResults = maxResults
        self.onBehalfOfContentOwner = onBehalfOfContentOwner
        self.order = order
        self.pageToken = pageToken
        self.publishedAfter = publishedAfter
        self.publishedBefore = publishedBefore
        self.searchQuery = searchQuery
        self.regionCode = regionCode
        self.safeSearch = safeSearch
        self.topicID = topicID
        self.resourceType = resourceType
        self.videoCaption = videoCaption
        self.videoCategoryID = videoCategoryID
        self.videoDefinition = videoDefinition
        self.videoDimension = videoDimension
        self.videoDuration = videoDuration
        self.videoEmbeddable = videoEmbeddable
        self.videoLicense = videoLicense
        self.videoSyndicated = videoSyndicated
        self.videoType = videoType
    }
}

