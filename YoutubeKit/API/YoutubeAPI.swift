//
//  ApiSession.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

@available(*, unavailable, renamed: "YoutubeAPI")
public class ApiSession {}

public class YoutubeAPI {

    public static let shared = YoutubeAPI()

    private init() {}

    public func send<T: Requestable>(_ request: T, queue: DispatchQueue = .main, completion: ((Result<T.Response, Error>) -> Void)? = nil) {

        let urlRequest = request.makeURLRequest()

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, rawResponse, error) in
            let result: Result<T.Response, Error>

            defer {
                queue.async {
                    completion?(result)
                }
            }

            // If the dataTask error is occured.
            if let error = error {
                result = .failure(ResponseError.unexpectedResponse(error))
                return
            }

            // Decodable must have data length at least.
            guard let data = data else {
                result = .failure(ResponseError.unexpectedResponse("The response is empty."))
                return
            }

            // rawResponse must be HTTPURLResponse
            guard let httpResponse = rawResponse as? HTTPURLResponse else {
                result = .failure(ResponseError.unexpectedResponse("The response is not a HTTPURLResponse"))
                return
            }

            // To successfully decode to T.Response.self, the status code must between 0 and 299
            guard (0..<300).contains(httpResponse.statusCode) else {
                result = .failure(ResponseError.unacceptableStatusCode(httpResponse.statusCode))
                return
            }

            // Decoding the response from `data` and handle DecodingError if occured.
            do {
                let decoder = JSONDecoder()
                result = .success(try decoder.decode(T.Response.self, from: data))
            } catch DecodingError.keyNotFound(let codingKey, let context){
                result = .failure(DecodingError.keyNotFound(codingKey, context))
            } catch DecodingError.typeMismatch(let type, let context){
                result = .failure(DecodingError.typeMismatch(type, context))
            } catch DecodingError.valueNotFound(let type, let context) {
                result = .failure(DecodingError.valueNotFound(type, context))
            } catch DecodingError.dataCorrupted(let context) {
                result = .failure(DecodingError.dataCorrupted(context))
            } catch {
                result = .failure(ResponseError.unexpectedResponse(data))
            }
        }
        task.resume()
    }
}
