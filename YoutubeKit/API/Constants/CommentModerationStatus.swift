//
//  CommentModerationStatus.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// This parameter can only be used in a properly authorized request. Set this parameter to limit the returned comment threads to a particular moderation state.
/// Note: - This parameter is not supported for use in conjunction with the id parameter. The default value is published.
/// reference: - https://developers.google.com/youtube/v3/docs/commentThreads/list
public enum CommentModerationStatus: String {
    
    /// Retrieve comment threads that are awaiting review by a moderator. A comment thread can be included in the response if the top-level comment or at least one of the replies to that comment are awaiting review.
    case heldForReview
    
    /// Retrieve comment threads classified as likely to be spam. A comment thread can be included in the response if the top-level comment or at least one of the replies to that comment is considered likely to be spam.
    case likelySpam
    
    /// Retrieve threads of published comments. This is the default value. A comment thread can be included in the response if its top-level comment has been published.
    case published
}
