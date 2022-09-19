//
//  ChannelSectionsListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/channelSections/list
public struct ChannelSectionsListRequest: Requestable {
    
    public typealias Response = ChannelSectionsList

    public var path: String {
        return "channelSections"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var isAuthorizedRequest: Bool {
        switch filter {
        case .channelID(_):
            return false
        case .id(_):
            return false
        case .mine(_):
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
        q.appendingQueryParameter(key: "hl", value: hl)
        q.appendingQueryParameter(key: "onBehalfOfContentOwner", value: onBehalfOfContentOwner)
        return q
    }

    // MARK: - Required parameters
    
    public let part: [Part.ChannelSectionsList]
    public let filter: Filter.ChannelSectionsList
    
    // MARK: - Option parameters
    
    public let hl: String?
    public let onBehalfOfContentOwner: String?
    
    public init(part: [Part.ChannelSectionsList],
                filter: Filter.ChannelSectionsList,
                hl: String? = nil,
                onBehalfOfContentOwner: String? = nil) {
        self.part = part
        self.filter = filter
        self.hl = hl
        self.onBehalfOfContentOwner = onBehalfOfContentOwner
    }
}
