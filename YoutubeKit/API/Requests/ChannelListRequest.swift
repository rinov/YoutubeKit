//
//  ChannelListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/channels/list
public struct ChannelListRequest: Requestable {
    
    public typealias Response = ChannelList

    public var path: String {
        return "channels"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var isAuthorizedRequest: Bool {
        switch filter {
        case .categoryID(_):
            return false
        case .id(_):
            return false
        case .managedByMe(_):
            return true
        case .mine(_):
            return true
        case .userName(_):
            return false
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
        q.appendingQueryParameter(key: "maxResult", value: maxResult)
        q.appendingQueryParameter(key: "onBehalfOfContentOwner", value: onBehalfOfContentOwner)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        return q
    }

    // MARK: - Required parameters
    
    public let part: [Part.ChannelList]
    public let filter: Filter.ChannelList
    
    // MARK: - Option parameters
    
    public let maxResult: Int?
    public let onBehalfOfContentOwner: String?
    public let pageToken: String?
    
    public init(part: [Part.ChannelList],
                filter: Filter.ChannelList,
                maxResult: Int? = nil,
                onBehalfOfContentOwner: String? = nil,
                pageToken: String? = nil) {
        self.part = part
        self.filter = filter
        self.maxResult = maxResult
        self.onBehalfOfContentOwner = onBehalfOfContentOwner
        self.pageToken = pageToken
    }
}

