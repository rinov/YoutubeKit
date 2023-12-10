//
//  ApiSession.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

@available(*, unavailable, renamed: "YoutubeAPI")
public class ApiSession {}

public class YoutubeAPI: NSObject {

    public static let shared = YoutubeAPI()

    private lazy var urlSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    private var taskHandlers: [URLSessionTask: (Data?, URLResponse?, Error?) -> Void] = [:]
    private var taskDataBuffer: [URLSessionTask: Data] = [:]

    private override init() {}

    public func send<T: Requestable>(_ request: T, queue: DispatchQueue = .main, completion: ((Result<T.Response, Error>) -> Void)? = nil) {
        let urlRequest = request.makeURLRequest()
        let task = urlSession.dataTask(with: urlRequest)

        taskDataBuffer[task] = Data()
        taskHandlers[task] = { data, response, error in
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
            guard let httpResponse = response as? HTTPURLResponse else {
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

extension YoutubeAPI: URLSessionDataDelegate {

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard var dataBuffer = taskDataBuffer[dataTask] else { return }
        dataBuffer.append(data)
        taskDataBuffer[dataTask] = dataBuffer
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let handler = taskHandlers[task], let dataBuffer = taskDataBuffer[task] else { return }
        handler(dataBuffer, task.response, error)
        taskHandlers[task] = nil
    }
}

