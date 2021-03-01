//
//  UIViewControllerExtensions.swift
//  FitnessWiki
//
//  Created by Andrei Mirzac on 26/02/2021.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, error: Error) {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}
