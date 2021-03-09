//
//  ExercisesListState.swift
//  
//
//  Created by Andrei Mirzac on 29/01/2021.
//

import Foundation
import ReSwift
import ReSwiftThunk

struct ExerciseListState: StateType {

    var paging: Paging<Exercise>?

    var filter: Filter?

    var isLoading: Bool = false

    var exercises: [Exercise] {
        return paging?.values ?? []
    }
}

enum ViewState<Data> {
    case loading
    case success(Data)
    case failure(Error)
}
