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
        let signUp: Signal<Void>
    }
    
    struct Output {
        let isLoggedIn: Driver<Bool>
        let signUp: Driver<Void>
    }
    
    private let coordinator: LoginCoordinator
    private let userRepository: UserRepository

    init(coordinator: LoginCoordinator, userRepository: UserRepository) {
        self.coordinator = coordinator
        self.userRepository = userRepository
    }
    
    func transform(input: Input) -> Output {
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let isLoggedIn = input.login
            .withLatestFrom(idAndPassword)
            .flatMapFirst { id, password in
                let requestDTO = LoginRequestDTO(email: id, password: password)
                return self.userRepository.login(with: requestDTO)
                    .asDriver(onErrorJustReturn: false)
            }
            .do(onNext: { isLoggedIn in
                if isLoggedIn == true {
                    self.coordinator.toTargetViewController()
                }
            })
        
        let signUp = input.signUp
            .do(onNext: coordinator.toSignUp)
            .asDriver(onErrorDriveWith: .empty())
        
        return .init(
            isLoggedIn: isLoggedIn,
            signUp: signUp
        )
    }
}
