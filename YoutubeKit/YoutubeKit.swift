//
//  YoutubeKit.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// 認証情報の読み書きをロックし、既存の同期setter/getterを維持する。
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

    private let credentialLock = NSLock()
    private var storedAPIKey = ""
    private var storedAccessToken = ""

    internal private(set) var _apiKey: String {
        get {
            credentialLock.lock()
            defer { credentialLock.unlock() }
            return storedAPIKey
        }
        set {
            credentialLock.lock()
            defer { credentialLock.unlock() }
            storedAPIKey = newValue
        }
    }

    internal private(set) var _accessToken: String {
        get {
            credentialLock.lock()
            defer { credentialLock.unlock() }
            return storedAccessToken
        }
        set {
            credentialLock.lock()
            defer { credentialLock.unlock() }
            storedAccessToken = newValue
        }
    }

    private init() {}
}

#if compiler(>=5.5)
// 可変の認証情報はすべてcredentialLock経由で読み書きする。
extension YoutubeKit: @unchecked Sendable {}
#endif
