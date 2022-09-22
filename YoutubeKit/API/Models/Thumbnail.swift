//
//  Thumbnail.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

// MARK: - Namespace
public enum Thumbnails {}

extension Thumbnails {
    public struct Default: Codable {
        public let url: String?
        public let height: Int?
        public let width: Int?
    }
}

extension Thumbnails {
    public struct SearchList: Codable {
        public let high: Default
        public let `default`: Default
        public let medium: Default
        
        public enum CodingKeys: String, CodingKey {
            case high
            case `default` = "default"
            case medium
        }
    }
}

extension Thumbnails {
    public struct VideoList: Codable {
        public let high: Default
        public let `default`: Default
        public let medium: Default
        
        public enum CodingKeys: String, CodingKey {
            case high
            case `default` = "default"
            case medium
        }
    }
}

extension Thumbnails {
    public struct ChannelList: Codable {
        public let high: Default
        public let `default`: Default
        public let medium: Default
        
        public enum CodingKeys: String, CodingKey {
            case high
            case `default` = "default"
            case medium
        }
    }
}

extension Thumbnails {
    public struct ActivityList: Codable {
        public let high: Default
        public let medium: Default
        public let `default`: Default
        public let standard: Default?
        public let maxres: Default?
        
        public enum CodingKeys: String, CodingKey {
            case high
            case medium
            case `default` = "default"
            case maxres
            case standard
        }
    }
}

extension Thumbnails {
    public struct PlaylistsList: Codable {
        public let high: Default
        public let medium: Default
        public let `default`: Default
        public let standard: Default?
        public let maxres: Default?
        
        public enum CodingKeys: String, CodingKey {
            case high = "high"
            case medium = "medium"
            case `default` = "default"
            case standard = "standard"
            case maxres = "maxres"
        }
    }
}

extension Thumbnails {
    public struct PlaylistItemsList: Codable {
        public let high: Default
        public let medium: Default
        public let `default`: Default
        
        public enum CodingKeys: String, CodingKey {
            case high = "high"
            case medium = "medium"
            case `default` = "default"
        }
    }
}
