//
//  MainTabBarController.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let homeNavigationController: UINavigationController = {
        let nc: UINavigationController = .init()
        nc.tabBarItem = .init(
            title: "홈",
            image: UIImage.init(systemName: "house"),
            selectedImage: UIImage.init(systemName: "house.fill")
        )
        return nc
    }()
    
    private let wishListNavigationController: UINavigationController = {
        let nc: UINavigationController = .init()
        nc.tabBarItem = .init(
            title: "찜목록",
            image: UIImage.init(systemName: "heart"),
            selectedImage: UIImage.init(systemName: "heart.fill")
        )
        return nc
    }()
    
    private let myPageNavigationController: UINavigationController = {
        let nc: UINavigationController = .init()
        nc.tabBarItem = .init(
            title: "내정보",
            image: UIImage.init(systemName: "person"),
            selectedImage: UIImage.init(systemName: "person.fill")
        )
        return nc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let homeCoordinator: HomeCoordinator = .init(navigationController: homeNavigationController)
        homeCoordinator.start()
        
        let wishListCoordinator: WishListCoordinator = .init(navigationController: wishListNavigationController)
        wishListCoordinator.start()
        
        let myPageCoordinator: MyPageCoordinator = .init(navigationController: myPageNavigationController)
        myPageCoordinator.start()
        
        self.viewControllers = [
            homeNavigationController,
            wishListNavigationController,
            myPageNavigationController,
        ]
        
        self.tabBar.backgroundColor = .systemGray6
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == myPageNavigationController || viewController == wishListNavigationController {
            // FIXME: 로그인 되어있는지 확인하는 로직 추가
            let isLoggedIn: Bool = false
            
            if isLoggedIn {
                return true
            } else {
                guard let presentingNC = tabBarController.selectedViewController as? UINavigationController else {
                    return false
                }
                let loginCoordinator: LoginCoordinator = .init(
                    navigationController: presentingNC,
                    tabBarController: tabBarController,
                    targetViewController: viewController
                )
                loginCoordinator.start()
                
                return false
            }
        }
        
        return true
    }
}
