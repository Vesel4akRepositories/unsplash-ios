//
//  URL+Extensions.swift
//  unsplash_practice
//
//  Created by Денис Петров on 22.09.2024.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(for request:  URLRequest, completion: @escaping (Result<T, Error>)-> Void) -> URLSessionTask {
        
        let fulfillmentCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillmentCompletionOnMainThread(.success(result))
                    } catch {
                        fulfillmentCompletionOnMainThread(.failure(error))
                    }
                } else {
                    fulfillmentCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillmentCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillmentCompletionOnMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
