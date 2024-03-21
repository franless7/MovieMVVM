//
//  HeaderTableView.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 21.03.2024.
//

import UIKit

protocol HeaderTableViewDelegate: AnyObject {
    func collectionTableViewCellDidTapCell(_ cell: HeaderCollectionTableViewCell, viewModel: TitleDetailViewViewModel)
}

class HeaderTableView: UITableView {
   
    weak var headerDelegate: HeaderTableViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .main
        
        register(HeaderCollectionTableViewCell.self, forCellReuseIdentifier: HeaderCollectionTableViewCell.identifier)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Airing Today"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: HeaderCollectionTableViewCell.identifier, for: indexPath) as? HeaderCollectionTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.backgroundColor = .main
        tableView.separatorStyle = .none
        MovieService.shared.execute(MovieRequest(endPoint: .airingToday),
                                    expecting: TrendingTitleResponse.self) { result in
            switch result {
            case .success(let titles):
                cell.configure(with: titles.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
}

extension HeaderTableView: HeaderCollectionTableViewCellDelegate {
    func collectionTableViewCellDidTapCell(_ cell: HeaderCollectionTableViewCell, viewModel: TitleDetailViewViewModel) {
        headerDelegate?.collectionTableViewCellDidTapCell(cell, viewModel: viewModel)
    }
}
