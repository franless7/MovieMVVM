//
//  MainTabBarViewController.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 23.02.2024.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .label
        configure()
        tabBar.barTintColor = .tabbar
    }
    
    private func configure() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: PersonViewController())
        let vc3 = UINavigationController(rootViewController: SearchResultViewController())
        let vc4 = UINavigationController(rootViewController: FavoritesViewController())
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        vc1.title = "Home"
        vc2.title = "Person"
        vc3.title = "Search"
        vc4.title = "Favorites"
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "person.3")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "star.fill")
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}
