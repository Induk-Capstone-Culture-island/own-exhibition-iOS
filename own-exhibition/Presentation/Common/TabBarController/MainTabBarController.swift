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
        
        let homeNavigationController: UINavigationController = .init()
        homeNavigationController.tabBarItem = .init(
            title: "홈",
            image: UIImage.init(systemName: "house"),
            selectedImage: UIImage.init(systemName: "house.fill")
        )
        let homeCoordinator: HomeCoordinator = .init(navigationController: homeNavigationController)
        homeCoordinator.start()
        
        let myPageVC = MyPageViewController.instantiate(withStoryboardName: "MyPage")
        let myPageTabBarItem = UITabBarItem.init(
            title: "내정보",
            image: UIImage.init(systemName: "person"),
            selectedImage: UIImage.init(systemName: "person.fill")
        )
        myPageVC.tabBarItem = myPageTabBarItem
        
        self.viewControllers = [homeNavigationController, myPageVC]
        
        self.tabBar.backgroundColor = .systemGray6
    }
}
