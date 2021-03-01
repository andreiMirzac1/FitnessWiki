//
//  ExerciseListAction.swift
//  
//
//  Created by Andrei Mirzac on 31/01/2021.
//

import Foundation
import ReSwift

enum ExercisesAction : Action {
    case set(filter: FilterEquipment)
    case fetched(_ exercises: [Exercise], page: PageData)
    case fetchedFailure(page: Error)
    case fetching
}

