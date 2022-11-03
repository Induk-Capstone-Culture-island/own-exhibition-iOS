//
//  HomeCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import UIKit

final class HomeCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "Home"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC: HomeViewController = .instantiate(withStoryboardName: storyboardName)
        let homeVM: HomeViewModel = .init(coordinator: self, exhibitionRepository: .init())
        homeVC.setViewModel(by: homeVM)
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    func toDetail(with exhibition: Exhibition) {
        let exhibitionDetailCoordinator: ExhibitionDetailCoordinator = .init(navigationController: navigationController)
        exhibitionDetailCoordinator.start(with: exhibition)
    }
}
