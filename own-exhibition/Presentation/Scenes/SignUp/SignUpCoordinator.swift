//
//  SignUpCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/22.
//

import UIKit

final class SignUpCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "SignUp"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signUpVC: SignUpViewController = .instantiate(withStoryboardName: storyboardName)
        let signUpVM: SignUpViewModel = .init(signUpCoordinator: self)
        signUpVC.setViewModel(by: signUpVM)
        navigationController.pushViewController(signUpVC, animated: true)
    }
}
