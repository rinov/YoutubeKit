//
//  YoutubeKit.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public final class YoutubeKit {

    public static let shared = YoutubeKit()
    public static let youtubeDataAPIVersion = "v3"

    public var apiKey: String {
        return _apiKey
    }

    public var accessToken: String {
        return _accessToken
    }

    public func setAPIKey(_ key: String) {
        self._apiKey = key
    }

    public func setAccessToken(_ token: String) {
        self._accessToken = token
    }

    internal private(set) var _apiKey: String = ""
    internal private(set) var _accessToken: String = ""

    private init() {}
}
