//
//  ExhibitionDetailCoordinator.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import UIKit

protocol ExhibitionDetailCoordinatorProtocol {
    func start(with exhibition: Exhibition)
    func toLoginView()
}

final class ExhibitionDetailCoordinator: ExhibitionDetailCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private let storyboardName: String = "ExhibitionDetail"
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with exhibition: Exhibition) {
        let exhibitionDetailVC: ExhibitionDetailViewController = .instantiate(withStoryboardName: storyboardName)
        let exhibitionDetailVM: ExhibitionDetailViewModel = .init(
            coordinator: self,
            exhibition: exhibition,
            userRepository: UserRepository.shared,
            keychainRepository: .init(),
            userDefaultsRepository: .init()
        )
        exhibitionDetailVC.setViewModel(by: exhibitionDetailVM)
        navigationController.pushViewController(exhibitionDetailVC, animated: true)
    }
    
    func toLoginView() {
        let loginCoordinator: LoginCoordinator = .init(
            navigationController: navigationController,
            targetViewController: navigationController
        )
        loginCoordinator.start()
    }
}
