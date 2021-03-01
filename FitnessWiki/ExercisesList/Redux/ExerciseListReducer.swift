//
//  ExerciseListReducer.swift
//  
//
//  Created by Andrei Mirzac on 31/01/2021.
//

import Foundation
import ReSwift

func exerciseListReducer(action: Action, state: ExerciseListState?) -> ExerciseListState {
    var state = state ?? ExerciseListState()
    guard let action = action as? ExercisesAction else {
        return state
    }
    
    state.isLoading = false

    switch action {

    case .set(let equipment):
        state.filter = FilterMapper().map(equipment)
        state.paging = nil

    case .fetched(let exercises, let pageData):
        var newContent = state.paging?.values ?? []
        newContent.append(contentsOf: exercises)
        state.paging = Paging(values: newContent, data: pageData)

    case .fetching:
        state.paging?.state = .loading
        state.isLoading = true

    case .fetchedFailure(let error):
        state.paging?.state = .failure(error)
    }

    return state
}
