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
    
    internal private(set) var apiKey: String = ""
    internal private(set) var accessToken: String = ""
    
    public func setAPIKey(_ key: String) {
        self.apiKey = key
    }
    
    public func setAccessToken(_ token: String) {
        self.accessToken = token
    }
    
    private init() {}
}
