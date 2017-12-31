//
//  BoolExtensions.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

extension Bool {
    
    // Convert swift boolean value to javascript boolean value.
    var jsValue: AnyObject {
        return (self ? "1" : "0") as AnyObject
    }
    
    // Convert swift boolean value to string literal.
    var literalString: String {
        return self ? "true" : "false"
    }
}
