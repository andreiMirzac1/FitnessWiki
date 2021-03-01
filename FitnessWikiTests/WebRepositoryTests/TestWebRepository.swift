//
//  TestWebRepository.swift
//  MyFitnessAppTests
//
//  Created by Andrei Mirzac on 07/02/2021.
//

import Foundation
@testable import FitnessWiki

class TestWebRepository: WebRepository {
    let session: URLSession = .mockedResponses
    let baseURL: String = "https://test.com"
    let queue: DispatchQueue = DispatchQueue(label: "test")
    
    func load(endpoint: TestWebRepository.API, completion: @escaping (Result<TestData, Error>) -> Void) {
        call(endpoint: endpoint, completion: completion)
    }
}

extension TestWebRepository {
    enum API: APICall {
        case test
        case urlError
        case bodyError
        case noHttpCodeError

        var path: String? {
            if self == .urlError {
                return "😋😋😋"
            }
            return "/test/path"
        }

        var queryItems: [URLQueryItem] {
            []
        }

        var method: String { "POST" }
        var headers: [String: String]? { nil }
        func body() throws -> Data? {
            return nil
        }
    }
}

extension TestWebRepository {
    enum APIError: Swift.Error, LocalizedError {
        case fail
        var errorDescription: String? { "fail" }
    }
}

extension TestWebRepository {
    struct TestData: Codable, Equatable {
        let string: String
        let integer: Int

        init() {
            string = "some string"
            integer = 42
        }
    }
}
