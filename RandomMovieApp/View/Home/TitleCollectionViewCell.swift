//
//  TitleCollectionViewCell.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 22.02.2024.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 7
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var imdbLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .yellow
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 7, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(imdbLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        imdbLabel.frame = CGRect(x: contentView.bounds.width - 50, y: 10, width: 40, height: 20)
    }

    public func configure(with model: String, voteAverage: Double) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterImageView.sd_setImage(with: url)
        imdbLabel.text = "IMDB \(String.formattedVoteAverage(voteAverage: voteAverage))"
    }
}
