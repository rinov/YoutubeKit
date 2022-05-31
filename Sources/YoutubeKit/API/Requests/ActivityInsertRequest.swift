//
//  ActivityInsertRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// SeeAlso: https://developers.google.com/youtube/v3/docs/activities/insert
import Foundation

public struct ActivityInsertRequest: Requestable {
    
    public typealias Response = ActivityList

    public var path: String {
        return "activities"
    }
    
    public var httpMethod: HTTPMethod {
        return .post
    }
    
    public var isAuthorizedRequest: Bool {
        return true
    }
    
    public var queryParameters: [String: Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)
        return q
    }
    
    public var httpBody: Data? {
        var json: [String: Any] = [:]
        var snippet: [String: String] = [:]
        var contentDetails: [String: Any] = [:]
        var bulletin: [String: Any] = [:]
        var resource: [String: String] = [:]

        snippet["description"] = description
        json["snippet"] = snippet

        guard let resourceID = resourceID else {
            return nil
        }
        
        if let kind = resourceID.kind {
            resource["kind"] = kind
        }
        if let channelID = resourceID.channelID {
            resource["channelId"] = channelID
        }
        if let playlistID = resourceID.playlistID {
            resource["playlistId"] = playlistID
        }
        if let videoID = resourceID.videoID {
            resource["videoId"] = videoID
        }
        
        bulletin["resourceId"] = resource
        contentDetails["bulletin"] = bulletin
        json["contentDetails"] = contentDetails

        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])

        return jsonData
    }

    // MARK: - Required parameters

    public let part: [Part.ActivityInsert]
    
    // MARK: - Option parameters

    public let description: String
    public let resourceID: ResourceID.ActivityInsert?
    
    public init(part: [Part.ActivityInsert],
                description: String,
                resourceID: ResourceID.ActivityInsert?) {
        self.part = part
        self.description = description
        self.resourceID = resourceID
    }
}
