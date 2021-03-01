//
//  SupplimentaryViewCell.swift
//  
//
//  Created by Andrei Mirzac on 21/02/2021.
//

import UIKit

class SupplimentaryViewCell: UICollectionReusableView {

    lazy var spinner = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(spinner)
        addConstraints()
    }

    func addConstraints() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        spinner.heightAnchor.constraint(equalToConstant: 44).activate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
