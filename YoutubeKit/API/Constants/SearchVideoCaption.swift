//
//  SearchVideoCaption.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchVideoCaption: String {
    
    /// Do not filter results based on caption availability.
    case any
    
    /// Only include videos that have captions.
    case closedCaption
    
    /// Only include videos that do not have captions.
    case none
}
