//
//  SearchVideoDimension.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchVideoDimension: String {
    
    /// Restrict search results to exclude 3D videos.
    case excludeThreeDimension = "2d"
    
    /// Restrict search results to only include 3D videos.
    case onlyThreeDimension = "3d"
    
    /// Include both 3D and non-3D videos in returned results. This is the default value.
    case any
}
