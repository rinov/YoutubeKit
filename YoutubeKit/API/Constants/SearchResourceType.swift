//
//  SearchResourceType.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types. The default value is video,channel,playlist.
public enum SearchResourceType: String {
    case channel
    case playlist
    case video
}
