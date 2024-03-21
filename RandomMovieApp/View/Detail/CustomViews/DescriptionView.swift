//
//  DescriptionView.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 17.03.2024.
//

import UIKit

class DescriptionView: UIView {
    
    lazy var topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isHidden = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Overview:"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(contentLabel)
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 20
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets.overviewViewComponentInset
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.addSubview(stack)

        stack.snp.makeConstraints { make in
          make.edges.equalToSuperview()
        }
        
        // Add Divider Line
        self.addSubview(topDivider)
        
        topDivider.snp.makeConstraints { make in
            make.height.equalTo(0.7)
            make.centerY.equalTo(self.snp.top)
            make.left.right.equalToSuperview()
        }
    }
}

