//
//  FavoritesViewController.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 23.02.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    private var titles: [TitleItem] = [TitleItem]()
    private var selectedTitle: TitleItem?
    
    public var favoritesTable: UITableView = {
    let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        view.addSubview(favoritesTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLocalStorageForDownload()
    }


    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDateBase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.favoritesTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesTable.frame = view.bounds
    }


}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        selectedTitle = titles[indexPath.row]

        cell.configure(with: TitleViewModel(titleName: title.title ?? "Unknown title name", posterUrl: title.posterUrl ?? "", voteAverage: title.voteAverage))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("selected item deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }

                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TitleDetailViewController()
        vc.delegate = self
        let title = titles[indexPath.row]
        guard let titleName = title.title else {
            return
        }
        YoutubeService.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                vc.configure(with: TitleDetailViewViewModel(title: titleName, posterUrl: title.posterUrl ?? "", titleOverview: title.titleOverview ?? "", youtubeView: videoElement, voteAverage: title.voteAverage, genreIds: []))
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension FavoritesViewController: TitleDetailDelegate {
    func didToggleFavorite(for viewModel: TitleDetailViewViewModel) {
        // Favori olan öğeyi silme işlemleri burada gerçekleştirilir
        if let index = titles.firstIndex(where: { $0.title == viewModel.title }) {
            DataPersistenceManager.shared.deleteTitleWith(model: titles[index]) { [weak self] result in
                switch result {
                case .success():
                    print("Selected item deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.titles.remove(at: index)
                self?.favoritesTable.reloadData() // Tabloyu güncelle
            }
        }
    }
}
