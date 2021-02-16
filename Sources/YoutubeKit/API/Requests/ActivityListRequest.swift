//
//  ActivityRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// SeeAlso: https://developers.google.com/youtube/v3/docs/activities/list
import Foundation

public struct ActivityListRequest: Requestable {
    
    public typealias Response = ActivityList

    public var path: String {
        return "activities"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var isAuthorizedRequest: Bool {
        switch filter {
        case .channelID(_):
            return false
        case .home(_):
            return true
        case .mine(_):
            return true
        }
    }
    
    public var queryParameters: [String: Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)
        let filterParam = filter.keyValue
        q[filterParam.key] = filterParam.value
        q.appendingQueryParameter(key: "maxResults", value: maxResults)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        q.appendingQueryParameter(key: "publishedAfter", value: publishedAfter)
        q.appendingQueryParameter(key: "publishedBefore", value: publishedBefore)
        q.appendingQueryParameter(key: "regionCode", value: regionCode)
        return q
    }
    
    // MARK: - Required parameters

    public let part: [Part.ActivityList]
    public let filter: Filter.ActivityList
    
    // MARK: - Option parameters

    public let maxResults: Int?
    public let pageToken: String?
    public let publishedAfter: Date?
    public let publishedBefore: Date?
    public let regionCode: String?

    public init(part: [Part.ActivityList],
                filter: Filter.ActivityList,
                maxResults: Int? = nil,
                pageToken: String? = nil,
                publishedAfter: Date? = nil,
                publishedBefore: Date? = nil,
                regionCode: String? = nil) {
        self.part = part
        self.filter = filter
        self.maxResults = maxResults
        self.pageToken = pageToken
        self.publishedAfter = publishedAfter
        self.publishedBefore = publishedBefore
        self.regionCode = regionCode
    }
}
