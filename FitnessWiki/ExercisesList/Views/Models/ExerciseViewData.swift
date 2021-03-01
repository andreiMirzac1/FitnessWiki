//
//  ExerciseViewData.swift
//  
//
//  Created by Andrei Mirzac on 08/02/2021.
//

import Foundation

struct ExerciseViewData {
    let name: String
    let category: String
    let muscles: String
    let imageURL: String?
}

extension ExerciseViewData {
    static func map(from exercise: Exercise) -> ExerciseViewData {
        ExerciseViewData(name: exercise.name,
                         category: exercise.category.name,
                         muscles: exercise.muscles.map({ $0.name }).joined(separator: ", "),
                         imageURL: exercise.images.first?.stringURL)
    }
}
