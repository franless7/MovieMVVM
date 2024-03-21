//
//  HeaderCollectionTableViewCell.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 21.03.2024.
//

import UIKit

protocol HeaderCollectionTableViewCellDelegate: AnyObject {
    func collectionTableViewCellDidTapCell(_ cell: HeaderCollectionTableViewCell, viewModel: TitleDetailViewViewModel)
}

class HeaderCollectionTableViewCell: UITableViewCell {

    static let identifier = "HeaderCollectionTableViewCell"
    
    private var titles: [Title] = [Title]()
    weak var delegate: HeaderCollectionTableViewCellDelegate?
    private var isTapped: Bool = false
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 400)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .main
        collectionView.register(TitleCollectionViewCell.self,
                                forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension HeaderCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier,
                                                            for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].posterPath else { return UICollectionViewCell() }
        let voteAverage = titles[indexPath.row].voteAverage
        cell.configure(with: model, voteAverage: voteAverage)

        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard !isTapped else { return }
        isTapped = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isTapped = false
        }
        
        let title = titles[indexPath.row]
        guard let titleName = title.originalTitle ?? title.name,
              let posterUrl = title.posterPath ?? title.backdropPath,
              let titleOverview = title.overview ?? title.originalName
        else {
            return
        }
        
        YoutubeService.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitleDetailViewViewModel(title: titleName,
                                                         posterUrl: posterUrl,
                                                         titleOverview: titleOverview,
                                                         youtubeView: videoElement,
                                                         voteAverage: title.voteAverage,
                                                         genreIds: title.genreIds)
                self?.delegate?.collectionTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                guard let strongSelf = self else {
                    return
                }
                print(error.localizedDescription)
                let emptyVideoElement = VideoElement(id: IdVideoElement(kind: "", videoId: ""))
                let viewModel = TitleDetailViewViewModel(title: titleName,
                                                         posterUrl: posterUrl,
                                                         titleOverview: titleOverview,
                                                         youtubeView: emptyVideoElement,
                                                         voteAverage: title.voteAverage,
                                                         genreIds: title.genreIds)
                self?.delegate?.collectionTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            }
        }
    }
}
