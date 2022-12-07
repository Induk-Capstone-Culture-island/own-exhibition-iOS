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
        let idValidation: Driver<Bool>
        let passwordValidation: Driver<Bool>
        var loginButtonEnable: Driver<Bool>
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
        let idValidation = input.id
            .map { self.validateID($0) }
        let passwordValidation = input.password
            .map { self.validatePassword($0) }
        
        let loginButtonEnable = Driver.combineLatest(
            idValidation,
            passwordValidation
        ).map { $0 && $1 }
        
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let autoLogin = input.viewWillAppear
            .flatMapFirst { _ -> Driver<Bool> in
                return .of(LoginStatusManager.shared.isLoggedIn)
            }
        
        let login = input.login
            .withLatestFrom(idAndPassword)
            .flatMapFirst { id, password -> Driver<Bool> in
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
            idValidation: idValidation,
            passwordValidation: passwordValidation,
            loginButtonEnable: loginButtonEnable,
            isLoggedIn: isLoggedIn,
            signUp: signUp
        )
    }
}

// MARK: - Private Functions

// FIXME: 중복 코드 - Validator 객체 이용
private extension LoginViewModel {
    
    func validateID(_ id: String) -> Bool {
        let idRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "(?=.*\\d)(?=.*[a-z])[a-zA-Z\\d]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
