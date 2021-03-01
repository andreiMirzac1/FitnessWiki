//
//  NetworkExercise.swift
//  
//
//  Created by Andrei Mirzac on 17/02/2021.
//

import Foundation

struct Exercise: Codable, Hashable {

    let uuid: String
    let id: Int
    let category: Category
    let detailDescription: String
    let name: String
    let muscles: [Muscle]
    let musclesSecondary:  [Muscle]
    let equipment:  [Category]
    let creationDate: String
    let images: [Image]
    let comments: [Comment]

    enum CodingKeys: String, CodingKey {
        case id, category
        case detailDescription = "description"
        case name
        case muscles
        case musclesSecondary = "muscles_secondary"
        case equipment
        case creationDate = "creation_date"
        case uuid
        case images
        case comments
    }
}

extension Exercise {

    struct Category: Codable, Hashable {
        let id: Int
        let name: String
    }

    struct Comment: Codable, Hashable {
        let id, exercise: Int
        let comment: String
    }

    // MARK: - Muscle
    struct Muscle: Codable, Hashable {
        let id: Int
        let name: String
        let isFront: Bool

        enum CodingKeys: String, CodingKey {
            case id, name
            case isFront = "is_front"
        }
    }

    struct Image: Codable, Hashable {
        let id, exercise: Int
        let stringURL: String
        let status: String
        let isMain: Bool

        enum CodingKeys: String, CodingKey {
            case id, exercise, status
            case stringURL = "image"
            case isMain = "is_main"
        }
    }
}
