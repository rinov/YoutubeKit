//
//  SearchVideoEmbeddable.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchVideoEmbeddable: String {
    
    /// Return all videos, embeddable or not.
    case any
    
    /// Only retrieve embeddable videos.
    case onlyEmbeddable = "true"
}
