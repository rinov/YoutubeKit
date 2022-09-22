//
//  RequestError.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

/// `RequestError` indicate that error is occurred when building a request.
public enum RequestError: Error {
    case invalidURLRequest(URLRequest)
    case missingRequiredParameter(String)
    case parameterLimitExceeded(String)
}
