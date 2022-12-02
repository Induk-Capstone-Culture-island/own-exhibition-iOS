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
    }
    
    struct Output {

        let selectedChangeName: Driver<UserInfo>
        let selectedChangeBirth: Driver<UserInfo>
        let selectedChangePhoneNumber: Driver<UserInfo>
        let selectedChangePassword: Driver<UserInfo>
        let userInfo: Driver<UserInfo>

    }
    
    private let coordinator: MyPageCoordinator
    private let userInfo: UserInfo
    
    init(coordinator: MyPageCoordinator, userInfo: UserInfo) {
        self.coordinator = coordinator
        self.userInfo = userInfo
    }
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewWillAppear
            .flatMapLatest { _ in
                return Driver<UserInfo>.of(self.userInfo)
            }
        
        let selectedChangeName = input.selectedChangeName
            .flatMapLatest { _ in
                return Driver<UserInfo>.of(self.userInfo)
            }
            .do(onNext: coordinator.changeInfo)
                
        let selectedChangePhoneNumber = input.selectedChangePhoneNumber
            .flatMapLatest { _ in
                return Driver<UserInfo>.of(self.userInfo)
            }
            .do(onNext: coordinator.changeInfo)
                
        let selectedChangeBirth = input.selectedChangeBirth
            .flatMapLatest { _ in
                return Driver<UserInfo>.of(self.userInfo)
            }
            .do(onNext: coordinator.changeInfo)
        
        let selectedChangePassword = input.selectedChangePassword
            .flatMapLatest { _ in
                return Driver<UserInfo>.of(self.userInfo)
            }
            .do(onNext: coordinator.toChangePasswordView)
                
        return .init(
            selectedChangeName: selectedChangePassword,
            selectedChangeBirth: selectedChangeName,
            selectedChangePhoneNumber: selectedChangeBirth,
            selectedChangePassword: selectedChangePhoneNumber,
            userInfo: userInfo
        )
    }
}
