//
//  ApiSession.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation

public class ApiSession {
    
    public static let shared = ApiSession()
    
    private init() {}
    
    public func send<T: Requestable>(_ request: T, closure: @escaping (Result<T.Response, Error>) -> Void) {
        
        let urlRequest = request.makeURLRequest()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, rawResponse, error) in
            
            // If the dataTask error is occured.
            if let error = error {
                DispatchQueue.main.async {
                    closure(.failed(ResponseError.unexpectedResponse(error)))
                }
                
                return
            }
            
            // Decodable must have data length at least.
            guard let data = data else {
                DispatchQueue.main.async {
                    closure(.failed(ResponseError.unexpectedResponse("The response is empty.")))
                }
                
                return
            }
            
            // rawResponse must be HTTPURLResponse
            guard let httpResponse = rawResponse as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    closure(.failed(ResponseError.unexpectedResponse("The response is not a HTTPURLResponse")))
                }
                
                return
            }
            
            // To successfully decode to T.Response.self, the status code must between 0 and 299
            guard (0..<300).contains(httpResponse.statusCode) else {
                do {
                    let errJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(errJson) //print error json object if data is serializable
                } catch let serializationError {
                    DispatchQueue.main.async {
                      closure(.failed(ResponseError.unexpectedResponse(serializationError)))
                    }
                }
                
                DispatchQueue.main.async {
                  closure(.failed(ResponseError.unacceptableStatusCode(httpResponse.statusCode)))
                }
                
                return
            }
          
            // Decoding the response from `data` and handle DecodingError if occured.
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.Response.self, from: data)
                
                DispatchQueue.main.async {
                  closure(.success(result))
                }
                
            } catch DecodingError.keyNotFound(let codingKey, let context){
                DispatchQueue.main.async {
                  closure(.failed(DecodingError.keyNotFound(codingKey, context)))
                }
                
            } catch DecodingError.typeMismatch(let type, let context){
                DispatchQueue.main.async {
                  closure(.failed(DecodingError.typeMismatch(type, context)))
                }
                
            } catch DecodingError.valueNotFound(let type, let context) {
                DispatchQueue.main.async {
                  closure(.failed(DecodingError.valueNotFound(type, context)))
                }
                
            } catch DecodingError.dataCorrupted(let context) {
                DispatchQueue.main.async {
                  closure(.failed(DecodingError.dataCorrupted(context)))
                }
                
            } catch {
                DispatchQueue.main.async {
                  closure(.failed(ResponseError.unexpectedResponse(data)))
                }
                
            }
        }
        
        task.resume()
    }
}
