//
//  PopularListView.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 11.03.2024.
//

import UIKit

protocol DetailListViewDelegate: AnyObject {
    func detailViewCellDidSelect(_ title: TitleDetailViewViewModel)
}

class MainDetailListView: UIView {
    
    weak var delegate: DetailListViewDelegate?
    private var titles: [Title] = [Title]()
    private var request: MovieRequest

    // MARK: - UI Elements
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: 10,
                                           bottom: 10,
                                           right: 10)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainTitleCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainTitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Inıt
    init(frame: CGRect, endPoint: MovieEndpoint) {
        self.request = MovieRequest(endPoint: endPoint)
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        fetchItems()
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        addConstraints()
        addSubview(activityIndicator)
        activityIndicator.center = self.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Functions
    private func fetchItems() {
        MovieService.shared.execute(request,
                                 expecting: TrendingTitleResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadNextPage() {
        request.incrementPage()
        MovieService.shared.execute(request,
                                 expecting: TrendingTitleResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let titlesResponse):
                DispatchQueue.main.async {
                    let newTitles = titlesResponse.results
                    self?.titles.append(contentsOf: newTitles)
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("Error fetching new data: \(error.localizedDescription)")
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
}

// MARK: - Extensions UICollectionView

extension MainDetailListView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainTitleCollectionViewCell.identifier, for: indexPath) as? MainTitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model = titles[indexPath.row]
        let viewModel = TitleViewModel(titleName: (model.originalTitle ?? model.originalName) ?? "",
                                       posterUrl: model.posterPath ?? "",
                                       voteAverage: model.voteAverage)
        cell.configure(with: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        
        guard let titleName = title.originalName ?? title.originalTitle,
              let posterUrl = title.posterPath,
        let titleOverview = title.overview else {
            return
        }
        
        let voteAverage = titles[indexPath.row].voteAverage
        
        YoutubeService.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                let viewModel = TitleDetailViewViewModel(
                    title: titleName,
                    posterUrl: posterUrl,
                    titleOverview: titleOverview,
                    youtubeView: videoElement, 
                    voteAverage: voteAverage,
                    genreIds: title.genreIds
                )
                self?.delegate?.detailViewCellDidSelect(viewModel)
            case .failure(let error):
                print(error.localizedDescription)
                let emptyVideoElement = VideoElement(id: IdVideoElement(kind: "", videoId: ""))
                let viewModel = TitleDetailViewViewModel(
                    title: titleName,
                    posterUrl: posterUrl,
                    titleOverview: titleOverview,
                    youtubeView: emptyVideoElement, 
                    voteAverage: title.voteAverage,
                    genreIds: title.genreIds
                )
                self?.delegate?.detailViewCellDidSelect(viewModel)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height && request.isCheckPageNumberThree == true {
            activityIndicator.startAnimating()
            loadNextPage()
        }
    }
}

// MARK: - Extension UICollectionViewLayout
extension MainDetailListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width,
                      height: width * 1.5
        )
    }
}
