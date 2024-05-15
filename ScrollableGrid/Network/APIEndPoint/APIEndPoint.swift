//
//  APIEndPoint.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 08/05/24.
//

import Foundation

enum APIEndPoint {

    case media_coverages
   
    private var endPoint: String {
        switch self {
        case .media_coverages: return "/media-coverages"
        }
    }

    var url: String {
        switch self {
        default:
            return baseURL + path + endPoint
        }
    }

}

protocol APIBuilder {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [APIHeaders] { get }
}

extension APIEndPoint: APIBuilder {

    internal var baseURL: String {
        switch self {
        default:
            return "https://acharyaprashant.org/api/v2/"
        }
        
    }

    internal var path: String {
        switch self {
        default: return "content/misc/"
        }
    }

    internal var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    internal var headers: [APIHeaders] {
        return [.jsonContentType, .accept]
    }
}



enum APIHeaders {
    
    case jsonContentType
    case accept

    func addHeader(_ request: inout URLRequest) {
        switch self {
        case .jsonContentType:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        case .accept:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        }
    }
}

enum DataError: Error {
    case network(Error)
    case errorWithMessage(String)
    case unknown
}

enum JSONDecoderError: Error {
    case decodingError
    case missingKey(String)
    case invalidData
    case otherError(Error)
}
