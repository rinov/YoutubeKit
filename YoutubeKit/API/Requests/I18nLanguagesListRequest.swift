//
//  I18nLanguagesListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// SeeAlso: https://developers.google.com/youtube/v3/docs/i18nLanguages/list
public struct I18nLanguagesListRequest: Requestable {
    
    public typealias Response = I18nLanguagesList

    public var path: String {
        return "i18nLanguages"
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
    
    public let part: [Part.I18nLanguagesList]
    
    // MARK: - Option parameters
    
    public let hl: String?
    
    public init(part: [Part.I18nLanguagesList],
                hl: String? = nil) {
        self.part = part
        self.hl = hl
    }
}

