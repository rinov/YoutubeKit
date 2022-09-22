//
//  ResponseError.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

/// `ResponseError` indicate that error is occurred when receiving a response.
public enum ResponseError: Error {
    case unacceptableStatusCode(Int)
    case unexpectedResponse(Any)
}
