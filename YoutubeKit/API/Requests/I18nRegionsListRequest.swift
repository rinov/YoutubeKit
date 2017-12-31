//
//  I18nRegionsListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/i18nRegions/list
public struct I18nRegionsListRequest: Requestable {
    
    public typealias Response = I18nRegionsList

    public var path: String {
        return "i18nRegions"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)
        q.appendingQueryParameter(key: "hl", value: hl)
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.I18nRegionsList]
    
    // MARK: - Option parameters
    
    public let hl: String?
    
    public init(part: [Part.I18nRegionsList],
                hl: String? = nil) {
        self.part = part
        self.hl = hl
    }
}
