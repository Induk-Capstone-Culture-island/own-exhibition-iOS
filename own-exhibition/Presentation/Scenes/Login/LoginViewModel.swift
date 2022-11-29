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
    
    private let coordinator: LoginCoordinator
    private let userRepository: UserRepository
    private let keychainRepository: KeychainRepository
    private let userDefaultsRepository: UserDefaultsRepository

    init(
        coordinator: LoginCoordinator,
        userRepository: UserRepository,
        keychainRepository: KeychainRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.coordinator = coordinator
        self.userRepository = userRepository
        self.keychainRepository = keychainRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func transform(input: Input) -> Output {
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let autoLogin = input.viewWillAppear
            .flatMapFirst { _ -> Driver<Bool> in
                guard let token = self.getCurrentToken() else { return .of(false) }
                
                return self.userRepository.getUserInfo(by: token)
                    .map { _ in true }
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let login = input.login
            .withLatestFrom(idAndPassword)
            .flatMapFirst { id, password in
                let requestDTO = LoginRequestDTO(email: id, password: password)
                return self.userRepository.login(with: requestDTO)
                    .asDriver(onErrorDriveWith: .empty())
            }
            .map { token in
                return self.saveIDAndToken(token)
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

private extension LoginViewModel {
    
    func getCurrentToken() -> Token? {
        guard let currentUserID = self.userDefaultsRepository.getCurrentUserId(),
              let token = self.keychainRepository.get(id: currentUserID)
        else {
            return nil
        }
        
        return token
    }
    
    func saveIDAndToken(_ token: Token) -> Bool {
        self.userDefaultsRepository.saveCurrentUserId(token.id)
        return self.keychainRepository.save(token: token)
    }
}
