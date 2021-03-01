//
//  Mockdata.swift
//  Tests
//
//  Created by Andrei Mirzac on 08/02/2021.
//

import Foundation
@testable import FitnessWiki

extension Exercise {
    static let mockExercises: [Exercise] = [
        Exercise(uuid: "1",
                        id: 1,
                        category: Exercise.Category(id: 1, name: "Shoulders"),
                        detailDescription: "Description of the exercise steps",
                        name: "Military Press",
                        muscles: [Exercise.Muscle(id: 1, name: "Shoulders", isFront: true)],
                        musclesSecondary: [],
                        equipment: [Exercise.Category(id: 1, name: "Barbell")],
                        creationDate: "23/02/2019",
                        images: [],
                        comments: []),
        Exercise(uuid: "2",
                        id: 2,
                        category: Exercise.Category(id: 2, name: "Shoulders"),
                        detailDescription: "Description of the exercise steps",
                        name: "Military Press",
                        muscles: [Exercise.Muscle(id: 2, name: "Shoulders", isFront: true)],
                        musclesSecondary: [],
                        equipment: [Exercise.Category(id: 2, name: "Barbell")],
                        creationDate: "23/02/2019",
                        images: [],
                        comments: [])
    ]

    static let mockedListingData: ListingData<[Exercise]> = ListingData(count: 0, next: "", previous: "", results: mockExercises)
}

extension NSError {
    static var test: NSError {
        return NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    }
}
