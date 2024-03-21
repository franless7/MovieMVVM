//
//  IconLabel.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 17.03.2024.
//

import UIKit

class IconLabel: UIView {
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(label)
        
        icon.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.width.equalTo(icon.snp.height)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // common func to init our view
    private func setupView() {
      self.addSubview(stack)
      
      stack.snp.makeConstraints { make in
          make.edges.equalToSuperview()
      }
    }
}
