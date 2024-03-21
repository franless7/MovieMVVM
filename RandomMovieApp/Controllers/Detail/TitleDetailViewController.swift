//
//  TitleDetailViewController.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 26.02.2024.
//

import UIKit
import SnapKit

class TitleDetailViewController: UIViewController {
    
    private var previewUrl: URL?
    private var genreIds: [Int]?
    
    // MARK: - UI Elements
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        return scrollView
    }()
    
    let contentView = UIView()
    
    // Header
    lazy var imageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imdbLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return label
    }()

    lazy var backDropImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .darkGray
        return image
    }()
    
    lazy var darkView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Buttons
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.tintColor = .white
        button.addTarget(nil, action: #selector(playButtonDidTapped), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .medium, scale: .default), forImageIn: .normal)
        return button
    }()
    
    @objc func playButtonDidTapped() {
        guard let url = previewUrl else { return }
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configureWebView(with: url)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "whiteheart"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonDidTapped), for: .touchUpInside)
       
        return button
    }()
    
    @objc private func favoriteButtonDidTapped() {
        favoriteButton.setImage(UIImage(named: "selectedheart"), for: .normal)
    }
    
    // Main Info
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 0
        label.minimumScaleFactor = 10
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    lazy var mainInfoLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal // Axis özelliğini horizontal olarak ayarlayın
        stack.spacing = 1
        stack.alignment = .leading
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets.detailViewComponentInset
        return stack
    }()
    
    // Overview
    lazy var overview: DescriptionView = {
        let overView = DescriptionView()
        overView.titleLabel.text = "Overview"
        return overView
    }()
    
    private func configureMainLabelStack() {
        if let genreIds = genreIds {
            let genreNames = GenreHandler.shared.genreNames(for: genreIds)
            
            for (index, genreName) in genreNames.prefix(3).enumerated() {
                let genreLabel = UILabel()
                genreLabel.textColor = .white
                genreLabel.text = genreName
                
                if genreNames.prefix(3).count > 1 && index < genreNames.prefix(3).count - 1 {
                    genreLabel.text?.append(" /")
                }
                
                genreLabel.textAlignment = .left
                genreLabel.setContentHuggingPriority(.required, for: .vertical)
                genreLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
                genreLabel.layoutMargins = UIEdgeInsets.detailViewComponentInset
               
                mainInfoLabelStack.addArrangedSubview(genreLabel)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpLayout()
        configureMainLabelStack()
    }
    
    private func setUpView() {
        self.view.backgroundColor = .main
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setUpLayout() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        contentView.addSubview(darkView)
        darkView.addSubview(imageContainerView)
        imageContainerView.addSubview(backDropImage)
       
        contentView.addSubview(mainInfoLabelStack)
        contentView.addSubview(overview)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imdbLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(favoriteButton)
        
        darkView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(550)
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(550)
        }

        playButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(imageContainerView)
            make.width.height.equalTo(30)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(10)
            make.right.equalTo(imageContainerView.snp.right).offset(-15)
            make.width.height.equalTo(30)
        }

        backDropImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainInfoLabelStack.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        overview.snp.makeConstraints { make in
            make.top.equalTo(mainInfoLabelStack.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottomMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageContainerView).offset(15)
            make.bottom.equalTo(imageContainerView).offset(-30)
            make.right.lessThanOrEqualTo(imageContainerView).inset(15)
        }
        
        imdbLabel.snp.makeConstraints { make in
            make.right.equalTo(imageContainerView).inset(15)
            make.bottom.equalTo(imageContainerView).offset(-30)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradient()
    }
    
    private func appendView(view: UIView, target: UIView) {
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
            make.top.equalTo(target.snp.bottom)
        }
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.frame = darkView.bounds // darkView'ın boyutlarına göre ayarla
        darkView.layer.addSublayer(gradientLayer) // darkView'a ekle
    }

    public func configure(with viewModel: TitleDetailViewViewModel) {
        self.genreIds = viewModel.genreIds
        titleLabel.text = viewModel.title
        overview.contentLabel.text = viewModel.titleOverview
        imdbLabel.text = String.formattedVoteAverage(voteAverage: viewModel.voteAverage)
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(viewModel.posterUrl)") else {
            return
        }
        guard let youtubeUrl = URL(string: "https://www.youtube.com/embed/\(viewModel.youtubeView.id.videoId)") else {
            return
        }
        
        previewUrl = youtubeUrl
        backDropImage.sd_setImage(with: url)
    }
}
