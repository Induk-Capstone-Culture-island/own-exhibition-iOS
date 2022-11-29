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
        let selection: Driver<Void>
    }
    
    struct Output {
        let userInfo: Driver<UserInfo>
        let selectedChangeInfo: Driver<UserInfo>
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
        
        let selectedChangeInfo = input.selection
            .flatMapLatest { _ in
                return Driver<UserInfo>.of(self.userInfo)
            }
            .do(onNext: coordinator.changeInfo)
                
        return .init(
            userInfo: userInfo,
            selectedChangeInfo: selectedChangeInfo
        )
    }
}
