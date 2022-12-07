//
//  LoginCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/15.
//

import UIKit

protocol LoginCoordinatorProtocol {
    func start()
    func toTargetViewController()
    func toSignUp()
}

final class LoginCoordinator: LoginCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "Login"
    private let targetViewController: UIViewController
    private weak var presentedNavigationController: UINavigationController!
    
    init(
        navigationController: UINavigationController,
        targetViewController: UIViewController
    ) {
        self.navigationController = navigationController
        self.targetViewController = targetViewController
    }
    
    func start() {
        let loginVC: LoginViewController = .instantiate(withStoryboardName: storyboardName)
        let loginVM: LoginViewModel = .init(coordinator: self, userRepository: UserRepository.shared)
        loginVC.setViewModel(by: loginVM)
        
        let presentedNavigationController: UINavigationController = .init()
        self.presentedNavigationController = presentedNavigationController
        presentedNavigationController.pushViewController(loginVC, animated: false)
        presentedNavigationController.modalTransitionStyle = .crossDissolve
        presentedNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(presentedNavigationController, animated: false)
    }
    
    func toTargetViewController() {
        guard let tabBarController = navigationController.tabBarController else {
            return
        }
        
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: false)
            tabBarController.selectedViewController = self.targetViewController
        }
    }
    
    func toSignUp() {
        let signUpCoordinator: SignUpCoordinator = .init(navigationController: presentedNavigationController)
        signUpCoordinator.start()
    }
}
