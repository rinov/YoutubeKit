//
//  SearchVideoDuration.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchVideoDuration: String {
    
    /// Do not filter video search results based on their duration. This is the default value.
    case any
    
    /// Only include videos longer than 20 minutes.
    case long
    
    /// Only include videos that are between four and 20 minutes long (inclusive).
    case medium
    
    /// Only include videos that are less than four minutes long.
    case short
}
