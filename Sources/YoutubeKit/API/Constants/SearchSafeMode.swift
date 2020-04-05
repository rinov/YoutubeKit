//
//  SearchSafeMode.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
public enum SearchSafeMode: String {
    
    /// YouTube will filter some content from search results and, at the least, will filter content that is restricted in your locale. Based on their content, search results could be removed from search results or demoted in search results. This is the default parameter value.
    case moderate
    
    /// YouTube will not filter the search result set.
    case none
    
    /// YouTube will try to exclude all restricted content from the search result set. Based on their content, search results could be removed from search results or demoted in search results.
    case strict
}
