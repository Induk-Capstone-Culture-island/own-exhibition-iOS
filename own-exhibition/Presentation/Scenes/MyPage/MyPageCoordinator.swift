//
//  MyPageCoordinator.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import UIKit

final class MyPageCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "MyPage"
    private let tabBarController: UITabBarController

    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func start() {
        let myPageVC: MyPageViewController = .instantiate(withStoryboardName: storyboardName)
        let myPageVM: MyPageViewModel = .init(
            coordinator: self,
            userRepository: UserRepository.shared,
            keychainRepository: .init(),
            userDefaultsRepository: .init()
        )
        myPageVC.setViewModel(by: myPageVM)
        navigationController.pushViewController(myPageVC, animated: false)
    }
    
    func toChangeInfo(with userInfo: UserInfo) {
        let changeInfoCoordinator: ChangeInfoCoordinator = .init(navigationController: navigationController)
        changeInfoCoordinator.start(with: userInfo)
    }
    
    func toChangePasswordView(with userInfo: UserInfo) {
        let changePasswordCoordinator: ChangePasswordCoordinator = .init(navigationController: navigationController)
        changePasswordCoordinator.start(with: userInfo)
    }
    
    func toHome() {
        tabBarController.selectedIndex = 0
    }
}
