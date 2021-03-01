//
//  MOck.swift
//  FitnessWikiTests
//
//  Created by Andrei Mirzac on 07/02/2021.
//

import Foundation
@testable import FitnessWiki

struct MockedResponse {
    let url: URL
    let result: Result<Data, Swift.Error>
    let httpCode: HTTPCode
    let headers: [String: String]
    let loadingTime: TimeInterval
    let customResponse: URLResponse?

    enum Error: Swift.Error {
        case failedMockCreation
    }
    init<T>(apiCall: APICall, baseURL: String,
            result: Result<T, Swift.Error>,
            httpCode: HTTPCode = 200,
            headers: [String: String] = ["Content-Type": "application/json"],
            loadingTime: TimeInterval = 0.1
    ) throws where T: Encodable {
        guard let url = try apiCall.urlRequest(baseURL: baseURL).url
            else { throw Error.failedMockCreation }
        self.url = url
        switch result {
        case let .success(value):
            self.result = .success(try JSONEncoder().encode(value))
        case let .failure(error):
            self.result = .failure(error)
        }
        self.httpCode = httpCode
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }

    init(url: URL, result: Result<Data, Swift.Error>) {
        self.url = url
        self.result = result
        httpCode = 200
        headers = [String: String]()
        loadingTime = 0
        customResponse = nil
    }
}
