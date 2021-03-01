//
//  FilterMapper.swift
//  
//
//  Created by Andrei Mirzac on 27/02/2021.
//

import Foundation

struct Filter {
    let id: Int
    let name: String
}

struct FilterMapper {
    func map(_ equipment: FilterEquipment) -> Filter? {
        var id: Int
        switch equipment {
        case .barbell:
            id = 1
        case .bodyweight:
            id = 7
        case .dumbbell:
            id = 3
        case .any:
            return nil
        }

        return Filter(id: id, name: "equipment")
    }
}
