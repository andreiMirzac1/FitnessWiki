//
//  ExerciseRepositoryTests.swift
//  MyFitnessAppTests
//
//  Created by Andrei Mirzac on 09/02/2021.
//

import XCTest
@testable import FitnessWiki

class ExerciseRepositoryTests: XCTestCase {
    let firstPage = "https://wger.de/api/v2/exercise/?language=2"
    var sut: RealExercisesWebRepository!
    typealias API = RealExercisesWebRepository.API

    override func setUp() {
        sut = RealExercisesWebRepository(session: .mockedResponses, baseURL: "https://test.com")
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }

    func test_exercisesWebRepository_fetchExercises() throws {
        let data = Exercise.mockedListingData
        try mock(.exercises(page: firstPage), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.fetchExercises(page: firstPage) { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertSuccess(value: data)
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
