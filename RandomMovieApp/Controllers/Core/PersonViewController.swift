//
//  UpcomingViewController.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 23.02.2024.
//

import UIKit

class PersonViewController: UIViewController {
    
    private lazy var personListView: PersonListView = {
        let view = PersonListView(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular People"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(personListView)
        addSearhButton()
        
        NSLayoutConstraint.activate([
            personListView.topAnchor.constraint(equalTo: view.topAnchor),
            personListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            personListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            personListView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    private func addSearhButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
}

