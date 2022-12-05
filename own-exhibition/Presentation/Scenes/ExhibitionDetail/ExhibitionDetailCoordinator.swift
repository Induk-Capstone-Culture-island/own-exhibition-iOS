//
//  ExhibitionDetailCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import UIKit

final class ExhibitionDetailCoordinator {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "ExhibitionDetail"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with exhibition: Exhibition) {
        let exhibitionDetailVC: ExhibitionDetailViewController = .instantiate(withStoryboardName: storyboardName)
        let exhibitionDetailVM: ExhibitionDetailViewModel = .init(
            exhibition: exhibition,
            userRepository: UserRepository.shared,
            keychainRepository: .init(),
            userDefaultsRepository: .init()
        )
        exhibitionDetailVC.setViewModel(by: exhibitionDetailVM)
        navigationController.pushViewController(exhibitionDetailVC, animated: true)
    }
}
