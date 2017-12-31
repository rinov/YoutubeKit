//
//  ResultOrder.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

// MARK: - Namespace
public enum ResultOrder {}

extension ResultOrder {
    public enum Search: String {
        case date
        case rating
        case relevance
        case title
        case videoCount
        case viewCount
    }
}

extension ResultOrder {
    public enum Subscriptions: String {
        case alphabetical
        case relevance
        case unread
    }
}

extension ResultOrder {
    
    /// The order parameter specifies the order in which the API response should list comment threads.
    /// Reference: https://developers.google.com/youtube/v3/docs/commentThreads/list
    public enum CommentThreads {
        
        /// Comment threads are ordered by time. This is the default behavior.
        case time
        
        /// Comment threads are ordered by relevance.
        /// Note: This parameter is not supported for use in conjunction with the id parameter.
        case relevance
    }
}
