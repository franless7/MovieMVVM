//
//  HomeHeaderUIView.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 22.02.2024.
//

import UIKit


class HomeHeaderUIView: UIView {
    
     let headerTableView: HeaderTableView = {
        let tableView = HeaderTableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(headerTableView)
        headerTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerTableView.topAnchor.constraint(equalTo: topAnchor),
            headerTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerTableView.frame = bounds
    }
}
