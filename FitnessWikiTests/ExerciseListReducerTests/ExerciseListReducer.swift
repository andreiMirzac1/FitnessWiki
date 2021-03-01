//
//  ExerciseListReducer.swift
//  Tests
//
//  Created by Andrei Mirzac on 12/02/2021.
//

import XCTest
import ReSwift
@testable import FitnessWiki

class ExerciseListReducer: XCTestCase {

    let mockExercises = Exercise.mockExercises

    let pageData = PageData(count: 3, next: "https://example/test", previous: "https://example/test")
    let lastPageData = PageData(count: 3, next: nil, previous: "https://example/test")

    func test_exerciseReducer_defaultState() throws {
        let state = ExerciseListState()
        XCTAssertEqual(state.exercises, [])
        XCTAssertNil(state.filter)
        XCTAssertFalse(state.isLoading)
        XCTAssertNil(state.paging)
    }

    func test_exerciseReducer_fetchedExerciseAction() throws {

        //Given
        let state = ExerciseListState()
        let action = ExercisesAction.fetched(mockExercises, page: pageData)
        //When
        let newState = exerciseListReducer(action: action, state: state)
        //Then
        XCTAssertEqual(newState.exercises, Exercise.mockExercises)
        XCTAssertEqual(newState.paging?.data, pageData)
        XCTAssertNil(newState.filter)
        XCTAssertFalse(newState.isLoading)
    }

    func test_exerciseReducer_fetchPagination() throws {
        //Given
        let state = ExerciseListState()
        let fetchAction1 = ExercisesAction.fetched([mockExercises[0]], page: pageData)
        let fetchAction2 = ExercisesAction.fetched([mockExercises[1]], page: lastPageData)
        //When
        let state1  = exerciseListReducer(action: fetchAction1, state: state)
        let newState = exerciseListReducer(action: fetchAction2, state: state1)

        //Then
        XCTAssertEqual(newState.exercises, Exercise.mockExercises)
        XCTAssertEqual(newState.paging?.data, lastPageData)
        XCTAssertNil(newState.filter)
    }


    func test_exerciseReducer_filterByEquipment() throws {
        //Given
        let state = ExerciseListState()
        let action = ExercisesAction.set(filter: .bodyweight)
        //When
        let newState = exerciseListReducer(action: action, state: state)
        //Then
        XCTAssertEqual(newState.exercises, [])
        XCTAssertNotNil(newState.filter)
    }
}
