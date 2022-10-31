//
//  MainTabBarController.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController.instantiate(withStoryboardName: "Home")
        let homeTabBarItem = UITabBarItem.init(
            title: "홈",
            image: UIImage.init(systemName: "house"),
            selectedImage: UIImage.init(systemName: "house.fill")
        )
        homeVC.tabBarItem = homeTabBarItem
        
        self.viewControllers = [homeVC]
        
        self.tabBar.backgroundColor = .systemGray6
    }
}
