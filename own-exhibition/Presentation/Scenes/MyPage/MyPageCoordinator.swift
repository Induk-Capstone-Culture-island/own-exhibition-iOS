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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let myPageVC: MyPageViewController = .instantiate(withStoryboardName: storyboardName)
        let myPageVM: MyPageViewModel = .init(coordinator: self, userInfo: .makemock())
        myPageVC.setViewModel(by: myPageVM)
        navigationController.pushViewController(myPageVC, animated: false)
    }
    
    func changeInfo(with userInfo: UserInfo) {
        let changeInfoCoordinator: ChangeInfoCoordinator = .init(navigationController: navigationController)
        changeInfoCoordinator.start(with: userInfo)
    }
}
