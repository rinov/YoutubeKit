//
//  SearchVideoType.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchVideoType: String {
    
    /// Return all videos.
    case any
    
    /// Only retrieve episodes of shows.
    case episode
    
    /// Only retrieve movies.
    case movie
}
