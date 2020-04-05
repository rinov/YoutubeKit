//
//  CommentTextFormat.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text. The default value is html.
/// Reference: https://developers.google.com/youtube/v3/docs/commentThreads/list
public enum CommentTextFormat: String {
    
    /// Returns the comments in HTML format. This is the default value.
    case html
    
    /// Returns the comments in plain text format.
    case plainText
}
