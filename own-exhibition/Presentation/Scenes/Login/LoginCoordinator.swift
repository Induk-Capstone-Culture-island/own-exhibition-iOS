//
//  LoginCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/15.
//

import UIKit

final class LoginCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "Login"
    private let tabBarController: UITabBarController
    private let targetViewController: UIViewController
    
    init(
        navigationController: UINavigationController,
        tabBarController: UITabBarController,
        targetViewController: UIViewController
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.targetViewController = targetViewController
    }
    
    func start() {
        let loginVC: LoginViewController = .instantiate(withStoryboardName: storyboardName)
        let loginVM: LoginViewModel = .init(coordinator: self)
        loginVC.setViewModel(by: loginVM)
        
        let presentedNC: UINavigationController = .init()
        presentedNC.pushViewController(loginVC, animated: false)
        presentedNC.modalTransitionStyle = .crossDissolve
        presentedNC.modalPresentationStyle = .fullScreen
        navigationController.present(presentedNC, animated: false)
    }
    
    func toTargetViewController() {
        navigationController.dismiss(animated: false)
        tabBarController.selectedViewController = targetViewController
    }
}
