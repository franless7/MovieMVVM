//
//  SearchBarView.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 10.03.2024.
//

// SearchBarView.swift

import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchViewDidSelectItem(_ viewModel: TitleDetailViewViewModel)
}

class SearchView: UIView {
    
    public weak var delegate: SearchViewDelegate?
    private var movieTitles: [Title] = []
    private var tvTitles: [Title] = []
    
    var query: String? {
        didSet {
            if let query = query {
                fetchSearchResult(query: query, shouldClearResults: true)
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 10,
                                           bottom: 0,
                                           right: 10)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainTitleCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainTitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    public func fetchSearchResult(query: String, shouldClearResults: Bool) {
        // Movie titles fetch
        SearchService.shared.execute(SearchRequest(endpoint: .searchMovie, query: query),
                                     expecting: TrendingTitleResponse.self)
        { [weak self] result in
            switch result {
            case .success(let titles):
                let filteredMovies = titles.results.filter { title in
                    guard let overview = title.overview,
                          let name = title.name ?? title.originalName,
                          let posterPath = title.posterPath ?? title.backdropPath else {
                        return false
                    }
                    return !overview.isEmpty && !name.isEmpty && !posterPath.isEmpty
                }
                self?.movieTitles = filteredMovies
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    if shouldClearResults {
                        self?.collectionView.setContentOffset(CGPoint.zero, animated: true) // Scrollview'i en üstüne getir
                    }
                }
            case .failure(let error):
                print("Movie titles fetch error: \(error.localizedDescription)")
            }
        }

        // TV titles fetch
        SearchService.shared.execute(SearchRequest(endpoint: .searchTv, query: query),
                                     expecting: TrendingTitleResponse.self)
        { [weak self] result in
            switch result {
            case .success(let titles):
                let filteredTvs = titles.results.filter { title in
                    guard let overview = title.overview,
                          let name = title.name ?? title.originalName,
                          let posterPath = title.posterPath ?? title.backdropPath else {
                        return false
                    }
                    return !overview.isEmpty && !name.isEmpty && !posterPath.isEmpty
                }
                self?.tvTitles = filteredTvs
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    if shouldClearResults {
                        self?.collectionView.setContentOffset(CGPoint.zero, animated: true) // Scrollview'i en üstüne getir
                    }
                }
            case .failure(let error):
                print("TV titles fetch error: \(error.localizedDescription)")
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieTitles.count + tvTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainTitleCollectionViewCell.identifier, for: indexPath) as? MainTitleCollectionViewCell else { return UICollectionViewCell() }
        
        var title: Title
        if indexPath.row < movieTitles.count {
            title = movieTitles[indexPath.row]
        } else {
            title = tvTitles[indexPath.row - movieTitles.count]
        }
        
        let viewModel = TitleViewModel(titleName: (title.originalName ?? title.originalTitle) ?? "",
                                       posterUrl: (title.posterPath ?? title.backdropPath) ?? "",
                                       voteAverage: title.voteAverage)
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedTitle: Title
        if indexPath.row < movieTitles.count {
            selectedTitle = movieTitles[indexPath.row]
        } else {
            selectedTitle = tvTitles[indexPath.row - movieTitles.count]
        }
        /// TODO Youtube Api Call
        let videoElement = VideoElement(id: IdVideoElement(kind: "", videoId: "")) /// Fix*******
        let viewModel = TitleDetailViewViewModel(
            title: ((selectedTitle.originalName ?? selectedTitle.name) ?? selectedTitle.originalTitle) ?? "",
            posterUrl: (selectedTitle.posterPath ?? selectedTitle.backdropPath) ?? "",
            titleOverview: selectedTitle.overview ?? "",
            youtubeView: videoElement,
            voteAverage: selectedTitle.voteAverage, 
            genreIds: selectedTitle.genreIds
        )
        
        delegate?.searchViewDidSelectItem(viewModel)
    }    
}

// MARK: - Extension UICollectionViewLayout

extension SearchView: UICollectionViewDelegateFlowLayout {
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
