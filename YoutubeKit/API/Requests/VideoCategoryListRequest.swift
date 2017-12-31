//
//  VideoCategoryListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/videoCategories/list
public struct VideoCategoriesListRequest: Requestable {
    
    public typealias Response = VideoCategoriesList
    
    public var path: String {
        return "videoCategories"
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

        let filterParam = filter.keyValue
        q[filterParam.key] = filterParam.value
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.VideoCategoriesList]
    public let filter: Filter.VideoCategoriesList
    
    // MARK: - Option parameters
    
    public let hl: String?
    
    public init(part: [Part.VideoCategoriesList],
                filter: Filter.VideoCategoriesList,
                hl: String? = nil) {
        self.part = part
        self.filter = filter
        self.hl = hl
    }
}
