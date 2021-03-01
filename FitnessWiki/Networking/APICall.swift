//
//  WebRepository.swift
//  MyFitnessApp
//
//  Created by Andrei Mirzac on 17/01/2021.
//

import Foundation

typealias HTTPCode = Int
enum NetworkError: Error {
    case invalidCode(HTTPCode)
    case unexpectedResponse
    case invalidURL
    case invalidData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .invalidCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .invalidData: return "Missing post body data"
        }
    }
}


protocol APICall {
    var path: String? { get } //TODO: Sort the path so it's not nil
    var method: String { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem] { get }
    func body() throws -> Data?
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let path = path else {
            throw NetworkError.invalidURL
        }

        var urlString = baseURL + path

        let queryString = queryItems
            .filter({ $0.value != nil })
            .compactMap({ "\($0.name)=\($0.value ?? "")" })
            .joined(separator: "&")

        if !queryString.isEmpty {
            urlString += "?\(queryString)"
        }

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()

        return request
    }
}
