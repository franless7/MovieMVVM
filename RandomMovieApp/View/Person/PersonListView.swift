//
//  PersonListView.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 29.02.2024.
//

import UIKit

class PersonListView: UIView {
    
    private var personItems: [Person] = [Person]()
    private var request: MovieRequest

    // MARK: - UI Elements
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
        collectionView.register(PersonCollectionViewCell.self,
                                forCellWithReuseIdentifier: PersonCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Inıt
    override init(frame: CGRect) {
        request = MovieRequest(endPoint: .person) 
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        getPersonItems()
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Functions
    private func getPersonItems() {
        MovieService.shared.execute(request, 
                                 expecting: PersonPopularResponse.self
        ) { result in
            switch result {
            case .success(let person):
                self.personItems = person.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadNextPage() {
        request.incrementPage()
        MovieService.shared.execute(request, 
                                 expecting: PersonPopularResponse.self
        ) { result in
            switch result {
            case .success(let personResponse):
                DispatchQueue.main.async {
                    let newPersons = personResponse.results
                    self.personItems.append(contentsOf: newPersons)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching new data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
}

// MARK: - Extensions

extension PersonListView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.identifier,
                                                      for: indexPath) as? PersonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model = personItems[indexPath.row]
        let viewModel = PersonListViewViewModel(name: (model.name ?? model.original_name) ?? "", 
                                        profileImage: model.profile_path ?? "")
        cell.configure(with: viewModel)
        return cell
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height && request.isCheckPageNumberFour == true {
            loadNextPage()
        }
    }
}

// MARK: - Extension UICollectionViewLayout
extension PersonListView: UICollectionViewDelegateFlowLayout {
    
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


