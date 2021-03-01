//
//  ExerciseViewCell.swift
//  
//
//  Created by Andrei Mirzac on 24/01/2021.
//

import UIKit
import Nuke

class ExerciseViewCell: UICollectionViewListCell {

    lazy var nameLabel = UILabel()
    lazy var categoryLabel = UILabel()
    lazy var imageView = UIImageView()
    lazy var containerView = UIStackView()

    private let placeHolder = UIImage(systemName: "photo.on.rectangle.angled")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        addSubviews()
        addConstraints()
        style()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        containerView.axis = .vertical
        containerView.spacing = 5
        imageView.contentMode = .scaleAspectFit
        accessories = [.disclosureIndicator()]
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        contentView.addSubview(imageView)

        containerView.addArrangedSubview(nameLabel)
        containerView.addArrangedSubview(categoryLabel)
    }

    private func addConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let layoutMargins = contentView.layoutMarginsGuide
        imageView.centerYAnchor.constraint(equalTo: layoutMargins.centerYAnchor).activate()
        imageView.leadingAnchor.constraint(equalTo: layoutMargins.leadingAnchor).activate()
        imageView.widthAnchor.constraint(equalToConstant: 45).activate()
        imageView.heightAnchor.constraint(equalToConstant: 45).activate()
        containerView.topAnchor.constraint(equalTo: layoutMargins.topAnchor).activate()
        containerView.bottomAnchor.constraint(equalTo: layoutMargins.bottomAnchor).activate()
        containerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).activate()
        containerView.trailingAnchor.constraint(equalTo: layoutMargins.trailingAnchor).activate()
    }

    func style() {
        categoryLabel.font = UIFont.systemFont(ofSize: 15)
        categoryLabel.textColor = .systemGray
    }
    
    func setup(exercise: ExerciseViewData) {
        nameLabel.text = exercise.name
        categoryLabel.text = exercise.category
        loadImage(with: exercise.imageURL)
    }

    private func loadImage(with stringURL: String?) {
        guard let stringURL = stringURL, let url = URL(string: stringURL) else {
            imageView.image = placeHolder
            return
        }

        let options = ImageLoadingOptions(
            placeholder: nil,
            transition: .fadeIn(duration: 0.33)
        )
        Nuke.loadImage(with: ImageRequest(url: url), options:options, into: imageView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        Nuke.cancelRequest(for: imageView)
        imageView.image = nil
    }
}

