//
//  APIManager.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 08/05/24.
//

import Foundation

class APIManager {
    
    static func callAPI<T: Decodable>(_ endPoint: APIEndPoint, type: T.Type, parameters: [String: String] = [String: String](), completion: @escaping (Result<T, DataError>) -> Void) {
        let urlComponents = NSURLComponents(string: endPoint.url)
        if !parameters.isEmpty {
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents?.queryItems = queryItems
        }
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.httpMethod = endPoint.method
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = 120
        endPoint.headers.forEach({ $0.addHeader(&urlRequest) })
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch let error {
                    switch error as? JSONDecoderError {
                        case .decodingError:
                            print("Decoding Error")
                        case .invalidData:
                            print("Invalid Data")
                        case .otherError(let error):
                            print("Other error: \(error.localizedDescription)")
                        case .missingKey(let string):
                            print("Missing key error \(string)")
                        case .none:
                            print("Unknown error")
                    }
                }
            } else {
                if let error = error {
                    completion(.failure(.network(error)))
                } else {
                    completion(.failure(.unknown))
                }
            }
            
        }.resume()
    }
}
