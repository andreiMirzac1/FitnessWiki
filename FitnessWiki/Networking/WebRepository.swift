//
//  WebRepository.swift
//  MyFitnessApp
//
//  Created by Andrei Mirzac on 17/01/2021.
//

import Foundation

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
    var queue: DispatchQueue { get }
}

extension WebRepository {
    func call<Value: Decodable>(endpoint: APICall, completion: @escaping (Result<Value, Error>) -> Void) {
        guard let request = try? endpoint.urlRequest(baseURL: baseURL) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            do {
                guard response is HTTPURLResponse else {
                    throw NetworkError.unexpectedResponse
                }

                guard let data = data else {
                    throw NetworkError.invalidData
                }

                let object = try JSONDecoder().decode(Value.self, from: data)
                DispatchQueue.main.async { completion(.success(object)) }
            } catch let error {
                return DispatchQueue.main.async { completion(Result.failure(error)) }
            }
        }

        task.resume()
    }
}




