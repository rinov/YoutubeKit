//
//  I18nLanguages.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public struct I18nLanguagesList: Codable {
    public let etag: String
    public let items: [I18nLanguage]
    public let kind: String
}

public struct I18nLanguage: Codable {
    public let etag: String
    public let id: String
    public let kind: String
    public let snippet: Snippet.I18nLanguagesList
}
