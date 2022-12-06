//
//  MyPageViewModel.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/10/28.
//

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Signal<Void>
        let selectedChangeName: Driver<Void>
        let selectedChangeBirth: Driver<Void>
        let selectedChangePhoneNumber: Driver<Void>
        let selectedChangePassword: Driver<Void>
        let tapLogoutButton: Signal<Void>
    }
    
    struct Output {
        let selectedChangeName: Driver<UserInfo>
        let selectedChangeBirth: Driver<UserInfo>
        let selectedChangePhoneNumber: Driver<UserInfo>
        let selectedChangePassword: Driver<UserInfo>
        let userInfo: Driver<UserInfo>
        let didTapLogoutButton: Signal<Void>
    }
    
    private let coordinator: MyPageCoordinator
    private let userRepository: UserRepositoryProtocol
    private let keychainRepository: KeychainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(
        coordinator: MyPageCoordinator,
        userRepository: UserRepositoryProtocol,
        keychainRepository: KeychainRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.coordinator = coordinator
        self.userRepository = userRepository
        self.keychainRepository = keychainRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewWillAppear
            .flatMapLatest { _ -> Driver<UserInfo> in
                guard let id = self.userDefaultsRepository.getCurrentUserId(),
                      let token = self.keychainRepository.get(id: id)
                else {
                    // FIXME: 토큰 유효하지 않을때 토큰 재 생성
                    return .empty()
                }
                
                return self.userRepository.getUserInfo(by: token)
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let selectedChangeName = input.selectedChangeName
            .flatMapLatest { _ -> Driver<UserInfo> in
                return .of(.makemock())
            }
            .do(onNext: coordinator.toChangeInfo)
                
        let selectedChangePhoneNumber = input.selectedChangePhoneNumber
            .flatMapLatest { _ -> Driver<UserInfo> in
                return .of(.makemock())
            }
            .do(onNext: coordinator.toChangeInfo)
                
        let selectedChangeBirth = input.selectedChangeBirth
            .flatMapLatest { _ -> Driver<UserInfo> in
                return .of(.makemock())
            }
            .do(onNext: coordinator.toChangeInfo)
        
        let selectedChangePassword = input.selectedChangePassword
            .flatMapLatest { _ -> Driver<UserInfo> in
                return .of(.makemock())
            }
            .do(onNext: coordinator.toChangePasswordView)
                
        let didTapLogoutButton = input.tapLogoutButton
            .do(onNext: {
                LoginStatusManager.shared.logout()
                self.coordinator.toHome()
            })
                
        return .init(
            selectedChangeName: selectedChangePassword,
            selectedChangeBirth: selectedChangeName,
            selectedChangePhoneNumber: selectedChangeBirth,
            selectedChangePassword: selectedChangePhoneNumber,
            userInfo: userInfo,
            didTapLogoutButton: didTapLogoutButton
        )
    }
}
