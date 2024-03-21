//
//  AllTitleCollectionViewCell.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 11.03.2024.
//

import UIKit

class MainTitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MainTitleCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var voteImageView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 7, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .main
        contentView.addSubview(imageView)
        imageView.addSubview(voteImageView)
        

        NSLayoutConstraint.activate([
            voteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            voteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            voteImageView.widthAnchor.constraint(equalToConstant: 40),
            voteImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with viewModel: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(viewModel.posterUrl)") else {
            return
        }
        imageView.sd_setImage(with: url, completed: nil)
        let formattedVoteAverage = String(format: "%.1f", viewModel.voteAverage)
        voteImageView.text = "IMDB \(formattedVoteAverage)"
    }
}
