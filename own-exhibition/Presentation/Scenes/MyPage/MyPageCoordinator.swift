//
//  MyPageCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/15.
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
        let myPageVM: MyPageViewModel = .init(myPageCoordinator: self)
        myPageVC.setViewModel(by: myPageVM)
        navigationController.pushViewController(myPageVC, animated: false)
    }
}
