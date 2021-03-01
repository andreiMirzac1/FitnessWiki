//
//  Networking.swift
//  FitnessWikiTests
//
//  Created by Andrei Mirzac on 07/02/2021.
//

import Foundation
@testable import FitnessWiki

final class RequestMocking: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let mock = RequestMocking.mock(for: request),
              let url = request.url,
              let response = mock.customResponse ??
                HTTPURLResponse(url: url,
                                statusCode: mock.httpCode,
                                httpVersion: "HTTP/1.1",
                                headerFields: mock.headers)  else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
            guard let self = self else { return }
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            switch mock.result {
            case let .success(data):
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            case let .failure(error):
                let failure = NSError(domain: NSURLErrorDomain, code: 1,
                                      userInfo: [NSUnderlyingErrorKey: error])
                self.client?.urlProtocol(self, didFailWithError: failure)
            }
        }
    }

    override func stopLoading() {
    }
}

extension RequestMocking {
    static private var mocks: [MockedResponse] = []

    static func add(mock: MockedResponse) {
        mocks.append(mock)
    }

    static func removeAllMocks() {
        mocks.removeAll()
    }

    static private func mock(for request: URLRequest) -> MockedResponse? {
        return mocks.first { $0.url == request.url }
    }
}


extension URLSession {
    static var mockedResponses: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [RequestMocking.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
}
