//
//  GuideCategoriesListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/guideCategories/list
// 廃止済みAPIの移行案内。既存コードの型とリクエスト形式は維持する。
@available(*, deprecated, message: "YouTubeはguideCategories.listを廃止しました。この型は既存コードの互換性のために保持しています。")
public struct GuideCategoriesListRequest: Requestable {
    
    public typealias Response = GuideCategoriesList

    public var path: String {
        return "guideCategories"
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
    
    public let part: [Part.GuideCategoriesList]
    public let filter: Filter.GuideCategoriesList
    
    // MARK: - Option parameters
    
    public let hl: String?
    
    public init(part: [Part.GuideCategoriesList],
                filter: Filter.GuideCategoriesList,
                hl: String? = nil) {
        self.part = part
        self.filter = filter
        self.hl = hl
    }
}

