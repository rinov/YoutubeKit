//
//  Result.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public enum Result<T, E> {
    case success(T)
    case failed(E)
}
