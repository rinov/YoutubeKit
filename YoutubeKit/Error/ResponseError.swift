//
//  ResponseError.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// 公開エラーの互換性。Anyを受け取る既存のケースを保持する。
/// `ResponseError` indicate that error is occurred when receiving a response.
public enum ResponseError: Error {
    case unacceptableStatusCode(Int)
    case unexpectedResponse(Any)
}

#if compiler(>=5.5)
// ErrorはSendableを要求するが、既存のAnyペイロードは公開契約として残す。
// 呼び出し側が可変参照を格納する場合、その同期責任は呼び出し側にある。
extension ResponseError: @unchecked Sendable {}
#endif
