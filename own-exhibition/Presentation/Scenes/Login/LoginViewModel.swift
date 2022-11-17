//
//  LoginViewModel.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/15.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let login: Signal<Void>
        let id: Driver<String>
        let password: Driver<String>
    }
    
    struct Output {
        let isLoggedIn: Driver<Bool>
    }
    
    private let coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let isLoggedIn = input.login
            .withLatestFrom(idAndPassword)
            .flatMapFirst { id, password in
                // FIXME: 로그인 처리 로직 추가
                return .of(true).asDriver()
            }
            .do(onNext: { isLoggedIn in
                if isLoggedIn == true {
                    self.coordinator.toTargetViewController()
                }
            })
                
        return .init(
            isLoggedIn: isLoggedIn
        )
    }
}