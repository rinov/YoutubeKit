//
//  SearchEventType.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the `SearchResourceType` parameter's value to video.
public enum SearchEventType: String {
    
    /// Only include completed broadcasts.
    case completed
    
    /// Only include active broadcasts.
    case live
    
    /// Only include upcoming broadcasts.
    case upcoming
}
