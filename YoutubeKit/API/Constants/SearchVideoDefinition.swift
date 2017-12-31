//
//  SearchVideoDefinition.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchVideoDefinition: String {
    
    /// Return all videos, regardless of their resolution.
    case any
    
    /// Only retrieve HD videos.
    case high
    
    /// Only retrieve videos in standard definition.
    case standard
}
