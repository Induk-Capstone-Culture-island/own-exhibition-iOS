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
        let viewWillAppear: Signal<Void>
        let login: Signal<Void>
        let id: Driver<String>
        let password: Driver<String>
        let signUp: Signal<Void>
    }
    
    struct Output {
        let isLoggedIn: Driver<Bool>
        let signUp: Driver<Void>
    }
    
    private let coordinator: LoginCoordinatorProtocol
    private let userRepository: UserRepositoryProtocol

    init(coordinator: LoginCoordinatorProtocol, userRepository: UserRepositoryProtocol) {
        self.coordinator = coordinator
        self.userRepository = userRepository
    }
    
    func transform(input: Input) -> Output {
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let autoLogin = input.viewWillAppear
            .flatMapFirst { _ -> Driver<Bool> in
                return .of(LoginStatusManager.shared.isLoggedIn)
            }
        
        let login = input.login
            .withLatestFrom(idAndPassword)
            .flatMapFirst { id, password in
                let requestDTO = LoginRequestDTO(email: id, password: password)
                return self.userRepository.getToken(with: requestDTO)
                    .do(onNext: LoginStatusManager.shared.login(with:))
                    .map { _ in true }
                    .asDriver(onErrorJustReturn: false)
            }
        
        let isLoggedIn = Driver.merge(login, autoLogin)
            .do(onNext: { isSuccess in
                if isSuccess {
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
