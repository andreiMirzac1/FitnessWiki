//
//  WebRepositoryTests.swift
//  MyFitnessAppTests
//
//  Created by Andrei Mirzac on 07/02/2021.
//

import XCTest
@testable import FitnessWiki

class WebRepositoryTests: XCTestCase {

    private var sut: TestWebRepository!
    private typealias API = TestWebRepository.API

    override func setUp() {
        sut = TestWebRepository()
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }

    func test_webRepository_shouldSucceed() throws {
        let data = TestWebRepository.TestData()
        try mock(.test, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.load(endpoint: .test) { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertSuccess(value: data)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func test_webRepository_withWrongData_returnsParseError() throws {
        let data = Exercise.mockedListingData
        try mock(.test, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.load(endpoint: .test) { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure("The data couldn’t be read because it is missing.")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }

    func test_webRepository_withInvalidUrl_returnsRequestURLError() {
        let exp = XCTestExpectation(description: "Completion")
        sut.load(endpoint: .urlError) { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure(NetworkError.invalidURL.localizedDescription)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func test_webRepository_withNoHttpCode_returnsUnexpectedResponse() {
        let exp = XCTestExpectation(description: "Completion")
        sut.load(endpoint: .noHttpCodeError) { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure(NetworkError.unexpectedResponse.localizedDescription)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    // MARK: - Helper
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try MockedResponse(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}

