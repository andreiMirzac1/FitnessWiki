//
//  Paging.swift
//  
//
//  Created by Andrei Mirzac on 21/02/2021.
//

import Foundation

struct PageData: Equatable {
    let count: Int
    let next: String?
    let previous: String?
}

struct PageDataMapper {
    func map(from data: ListingData<[Exercise]>) -> PageData {
        PageData(count: data.count,
                 next: data.next,
                 previous: data.previous)
    }
}
