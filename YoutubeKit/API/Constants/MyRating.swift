//
//  MyRating.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// This parameter can only be used in a properly authorized request. Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
public enum MyRating: String {
    
    /// Returns only videos disliked by the authenticated user.
    case like
    
    /// Returns only video liked by the authenticated user.
    case dislike
}
