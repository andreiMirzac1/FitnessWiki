//
//  StringExtensions.swift
//  MyFitnessApp
//
//  Created by Andrei Mirzac on 23/12/2020.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
