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
    private let presentedNavigationController: UINavigationController = .init()
    
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
        
        presentedNavigationController.pushViewController(loginVC, animated: false)
        presentedNavigationController.modalTransitionStyle = .crossDissolve
        presentedNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(presentedNavigationController, animated: false)
    }
    
    func toTargetViewController() {
        navigationController.dismiss(animated: false)
        tabBarController.selectedViewController = targetViewController
    }
    
    func toSignUp() {
        let signUpCoordinator: SignUpCoordinator = .init(navigationController: presentedNavigationController)
        signUpCoordinator.start()
    }
}
