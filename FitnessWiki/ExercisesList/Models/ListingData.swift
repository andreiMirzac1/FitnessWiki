//
//  PageData.swift
//  
//
//  Created by Andrei Mirzac on 16/02/2021.
//

import Foundation

struct ListingData<Data: Codable & Hashable>: Codable, Hashable {
    let count: Int
    let next: String?
    let previous: String?
    let results: Data
}
