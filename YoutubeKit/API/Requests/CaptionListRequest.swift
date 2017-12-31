//
//  CaptionListRequest.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// SeeAlso: https://developers.google.com/youtube/v3/docs/captions/list
public struct CaptionListRequest: Requestable {
    
    public typealias Response = CaptionList

    public var path: String {
        return "captions"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var isAuthorizedRequest: Bool {
        return true
    }
    
    public var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)
        q.appendingQueryParameter(key: "videoId", value: videoID)
        q.appendingQueryParameter(key: "id", value: id)
        q.appendingQueryParameter(key: "onBehalfOfContentOwner", value: onBehalfOfContentOwner)
        return q
    }
    
    // MARK: - Required parameters

    public let part: [Part.CaptionList]
    public let videoID: String
    
    // MARK: - Option parameters
    
    public let id: String?
    public let onBehalfOfContentOwner: String?

    public init(part: [Part.CaptionList],
                videoID: String,
                id: String? = nil,
                onBehalfOfContentOwner: String? = nil) {
        self.part = part
        self.videoID = videoID
        self.id = id
        self.onBehalfOfContentOwner = onBehalfOfContentOwner
    }
}
