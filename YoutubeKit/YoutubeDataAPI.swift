//
//  YoutubeDataAPI.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// SeeAlso: - https://developers.google.com/youtube/v3/docs/
public final class YoutubeDataAPI {

    public static let version = "v3"

    public enum ApprovalPrompt: String {
        case auto
        case force
    }

    public enum Scope: String {
        case admin = "https://www.googleapis.com/auth/youtube"
        case readOnly = "https://www.googleapis.com/auth/youtube.readonly"
        case upload = "https://www.googleapis.com/auth/youtube.upload"
        case channelAudit = "https://www.googleapis.com/auth/youtubepartner-channel-audi"
    }
}
