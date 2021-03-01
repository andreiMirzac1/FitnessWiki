//
//  Store.swift
//  
//
//  Created by Andrei Mirzac on 27/02/2021.
//

import Foundation
import ReSwift
import ReSwiftThunk

let thunkMiddleware: Middleware<ExerciseListState> = createThunkMiddleware()
let exercisesStore = Store(reducer: exerciseListReducer,
                           state: ExerciseListState(),
                           middleware: [thunkMiddleware])
