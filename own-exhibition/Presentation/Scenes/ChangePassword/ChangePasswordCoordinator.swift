//
//  ChangePasswordCoordinator.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/27.
//

import UIKit

final class ChangePasswordCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "ChangePassword"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with personalInfo: PersonalInfo) {
        let changePasswordVC: ChangePasswordViewController = .instantiate(withStoryboardName: storyboardName)
        let changePasswordVM: ChangePasswordViewModel = .init(personalInfo: personalInfo)
        changePasswordVC.setViewModel(by: changePasswordVM)
        navigationController.pushViewController(changePasswordVC, animated: true)
    }
}
