//
//  SignUpCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/22.
//

import UIKit

protocol SignUpCoordinatorProtocol {
    func start()
}

final class SignUpCoordinator: SignUpCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "SignUp"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signUpVC: SignUpViewController = .instantiate(withStoryboardName: storyboardName)
        let signUpVM: SignUpViewModel = .init(signUpCoordinator: self, userRepository: UserRepository.shared)
        signUpVC.setViewModel(by: signUpVM)
        navigationController.pushViewController(signUpVC, animated: true)
    }
}
