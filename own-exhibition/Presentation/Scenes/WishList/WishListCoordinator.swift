//
//  WishListCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/23.
//

import UIKit

final class WishListCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "WishList"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let wishListVC: WishListViewController = .instantiate(withStoryboardName: storyboardName)
        let wishListVM: WishListViewModel = .init(coordinator: self, exhibitionRepository: .init())
        wishListVC.setViewModel(by: wishListVM)
        navigationController.pushViewController(wishListVC, animated: false)
    }
    
    func toDetail(with exhibition: Exhibition) {
        let exhibitionDetailCoordinator: ExhibitionDetailCoordinator = .init(navigationController: navigationController)
        exhibitionDetailCoordinator.start(with: exhibition)
    }
    
}
