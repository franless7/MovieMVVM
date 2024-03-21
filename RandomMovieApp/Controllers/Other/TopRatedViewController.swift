//
//  TopRatedViewController.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 11.03.2024.
//

import UIKit

class TopRatedViewController: UIViewController {

    let detailListView = MainDetailListView(frame: .zero, endPoint: .topRated)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addSearchButton()
        addConstraints()
        detailListView.delegate = self
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        title = "Top Rated"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        view.addSubview(detailListView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailListView.topAnchor.constraint(equalTo: view.topAnchor),
            detailListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailListView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }

}
// MARK: - Extension
extension TopRatedViewController: DetailListViewDelegate {
    func detailViewCellDidSelect(_ title: TitleDetailViewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let detailVC = TitleDetailViewController()
            detailVC.configure(with: title)
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
