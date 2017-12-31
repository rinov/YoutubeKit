//
//  PageInfo.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

public struct PageInfo: Codable {
    public let resultsPerPage: Int
    public let totalResults: Int
    
    public init(resultsPerPage: Int, totalResults: Int) {
        self.resultsPerPage = resultsPerPage
        self.totalResults = totalResults
    }
}

extension PageInfo {
    public enum CodingKeys: String, CodingKey {
        case resultsPerPage
        case totalResults
    }
}
