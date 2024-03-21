//
//  PersonCollectionViewCell.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 29.02.2024.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PersonCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18,
                                 weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    
    public func configure(with viewModel: PersonListViewViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(viewModel.profileImage)") else {
            return
        }
        imageView.sd_setImage(with: url, completed: nil)
        nameLabel.text = viewModel.name
    }
}
