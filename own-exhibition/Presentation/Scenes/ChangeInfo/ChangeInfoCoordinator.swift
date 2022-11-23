//
//  ChangeInfoCoordinator.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import UIKit

final class ChangeInfoCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "ChangeInfo"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with personalInfo: PersonalInfo) {
        let changeInfoVC: ChangeInfoViewController = .instantiate(withStoryboardName: storyboardName)
        let changeInfoVM: ChangeInfoViewModel = .init(personalInfo: personalInfo)
        changeInfoVC.setViewModel(by: changeInfoVM)
        navigationController.pushViewController(changeInfoVC, animated: true)
    }
}
