//
//  VideoListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// SeeAlso: https://developers.google.com/youtube/v3/docs/videos/list
public struct VideoListRequest: Requestable {
    
    public typealias Response = VideoList
    
    public var path: String {
        return "videos"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var isAuthorizedRequest: Bool {
        switch filter {
        case .chart:
            return false
        case .id(_):
            return false
        case .myRating(_):
            return true
        }
    }
    
    public var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)
        let filterParam = filter.keyValue
        q[filterParam.key] = filterParam.value
        q.appendingQueryParameter(key: "maxResults", value: maxResults)
        q.appendingQueryParameter(key: "onBehalfOfContentOwner", value: onBehalfOfContentOwner)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        q.appendingQueryParameter(key: "regionCode", value: regionCode)
        q.appendingQueryParameter(key: "videoCategoryID", value: videoCategoryID)
        return q
    }

    // MARK: - Required parameters
    
    public let part: [Part.VideoList]
    public let filter: Filter.VideoList
    
    // MARK: - Option parameters

    public let maxResults: Int?
    public let onBehalfOfContentOwner: String?
    public let pageToken: String?
    public let regionCode: String?
    public let videoCategoryID: String?
    
    public init(part: [Part.VideoList],
                filter: Filter.VideoList,
                maxResults: Int? = nil,
                onBehalfOfContentOwner: String? = nil,
                pageToken: String? = nil,
                regionCode: String? = nil,
                videoCategoryID: String? = nil) {
        self.part = part
        self.filter = filter
        self.maxResults = maxResults
        self.onBehalfOfContentOwner = onBehalfOfContentOwner
        self.pageToken = pageToken
        self.regionCode = regionCode
        self.videoCategoryID = videoCategoryID
    }
}
