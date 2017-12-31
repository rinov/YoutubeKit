//
//  SearchVideoSyndicated.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchVideoSyndicated: String {
    
    /// Return all videos, syndicated or not.
    case any
    
    /// Only retrieve syndicated videos.
    case onlySyndicated = "true"
}
