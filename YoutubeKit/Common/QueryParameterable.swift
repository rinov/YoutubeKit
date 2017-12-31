//
//  QueryParameterable.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

public protocol QueryParameterable {
    var keyValue: (key: String, value: Any) { get }
}
