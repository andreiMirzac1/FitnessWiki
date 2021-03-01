//
//  UICollectionReusableViewExtensions.swift
//  FitnessWiki
//
//  Created by Andrei Mirzac on 25/01/2021.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
