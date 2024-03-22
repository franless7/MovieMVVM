//
//  HomeViewController.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 23.02.2024.
//

import UIKit

enum Sections: Int {
    case Popular = 0
    case TrendingMovies = 1
    case TrendingTv = 2
    case Upcoming = 3
    case TopRated = 4
}

final class HomeViewController: UIViewController {
    
    private let sectionTitles: [String] = [
        "Popular",
        "Trending movie",
        "Trending tv's",
        "Upcoming",
        "Top rated",
    ]

    private var headerView: HomeHeaderUIView?
    private var randomTrendingMovie: Title?

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .main
        table.register(CollectionTableViewCell.self,
                       forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
  
        headerView = HomeHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        addSearhButton()
        
        headerView?.headerTableView.headerDelegate = self
    }
    
    private func setUpView() {
        view.backgroundColor = .main
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(homeFeedTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Functions

    private func addSearhButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchVc = SearchViewController()
        searchVc.searchView.delegate = self
        navigationController?.pushViewController(searchVc, animated: true)
    }

    @objc func seeMoreButtonDidTapped(_ sender: UIButton) {
        guard let section = Sections(rawValue: sender.tag) else { return }
        switch section {
        case .Popular:
            let popularVC = PopularViewController()
            navigationController?.pushViewController(popularVC, animated: true)
        case .TrendingMovies:
            let trendingMoviesVC = TrendingMoviesViewController()
            navigationController?.pushViewController(trendingMoviesVC, animated: true)
        case .TrendingTv:
            let trendingTvVC = TrendingTvViewController()
            navigationController?.pushViewController(trendingTvVC, animated: true)
        case .Upcoming:
            let upcomingVC = UpcomingViewController()
            navigationController?.pushViewController(upcomingVC, animated: true)
        case .TopRated:
            let topRatedVC = TopRatedViewController()
            navigationController?.pushViewController(topRatedVC, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

// MARK: - Delegate & DataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        let seeMoreButton = UIButton(type: .system)
        seeMoreButton.setTitle("See More", for: .normal)
        seeMoreButton.tintColor = .white
        seeMoreButton.tag = section
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonDidTapped), for: .touchUpInside)
        seeMoreButton.configuration?.buttonSize = .mini
        header.addSubview(seeMoreButton)
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeMoreButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -5),
        ])
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 25,
                                         y: header.bounds.origin.y,
                                         width: 100,
                                         height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier,
                                                       for: indexPath) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        
        tableView.separatorStyle = .none
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.Popular.rawValue:
            MovieService.shared.execute(
                MovieRequest(endPoint: .popularMovie),
                expecting: TrendingTitleResponse.self
            ) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingMovies.rawValue:
            MovieService.shared.execute(
                MovieRequest(endPoint: .trendingMovie),
                expecting: TrendingTitleResponse.self
            ) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            MovieService.shared.execute(
                MovieRequest(endPoint: .trendingTv),
                expecting: TrendingTitleResponse.self
            ) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            MovieService.shared.execute(
                MovieRequest(endPoint: .upComingMovie),
                expecting: TrendingTitleResponse.self
            ) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            MovieService.shared.execute(
                MovieRequest(endPoint: .topRated),
                expecting: TrendingTitleResponse.self
            ) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}

// MARK: - Extensions
extension HomeViewController: CollectionTableViewCellDelegate {
    func collectionTableViewCellDidTapCell(_ cell: CollectionTableViewCell,
                                           viewModel: TitleDetailViewViewModel) {
            let vc = TitleDetailViewController()
            vc.configure(with: viewModel)
            navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: SearchViewDelegate {
    func searchViewDidSelectItem(_ viewModel: TitleDetailViewViewModel) {
            let vc = TitleDetailViewController()
            vc.configure(with: viewModel)
            navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: HeaderTableViewDelegate {
    func collectionTableViewCellDidTapCell(_ cell: HeaderCollectionTableViewCell, viewModel: TitleDetailViewViewModel) {
            let vc = TitleDetailViewController()
            vc.configure(with: viewModel)
            navigationController?.pushViewController(vc, animated: true)
    }
}
