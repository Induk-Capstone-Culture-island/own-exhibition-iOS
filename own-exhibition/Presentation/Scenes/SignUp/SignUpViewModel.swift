//
//  SignUpViewModel.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/22.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    struct Input {
        let id: Driver<String>
        let password: Driver<String>
        let repassword: Driver<String>
        let userName: Driver<String>
        let birthday: Driver<Date>
        let phoneNumber: Driver<String>
        let signUp: Signal<Void>
    }
    
    struct Output {
        let idValidation: Driver<Bool>
        let passwordValidation: Driver<Bool>
        let nameValidation: Driver<Bool>
        let phoneNumberValidation: Driver<Bool>
        var signUpButtonEnable: Driver<Bool>
        let signUp: Driver<Void>
    }
    
    private let signUpCoordinator: SignUpCoordinator
    private let userRepository: UserRepository
    
    init(signUpCoordinator: SignUpCoordinator, userRepository: UserRepository) {
        self.signUpCoordinator = signUpCoordinator
        self.userRepository = userRepository
    }
    
    func transform(input: Input) -> Output {
        let idValidation = input.id
            .map { self.validateID($0) }
        let passwordValidation = Driver.combineLatest(input.password, input.repassword)
            .map { self.validatePassword($0, $1) }
        let nameValidation = input.userName
            .map { self.validateName($0) }
        let phoneNumberValidation = input.phoneNumber
            .map { self.validatePhoneNumber($0) }
        
        let signUpButtonEnable = Driver.combineLatest(
            idValidation,
            passwordValidation,
            nameValidation,
            phoneNumberValidation
        ).map { $0 && $1 && $2 && $3 }
        
        let signUpRequestDTO = Driver.combineLatest(
            input.userName,
            input.id,
            input.password,
            input.birthday
                .map {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    return formatter.string(from: $0)
                }
        )
            .map { SignUpRequestDTO.init(name: $0, email: $1, password: $2, birthday: $3) }
        
        let signUp = input.signUp
            .withLatestFrom(signUpRequestDTO)
            .flatMapFirst { requestDTO in
                return self.userRepository.createUser(with: requestDTO)
                    .do(onNext: LoginStatusManager.shared.login(with:))
                    .map { _ -> Void in }
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        return .init(
            idValidation: idValidation,
            passwordValidation: passwordValidation,
            nameValidation: nameValidation,
            phoneNumberValidation: phoneNumberValidation,
            signUpButtonEnable: signUpButtonEnable,
            signUp: signUp
        )
    }
}

// MARK: - Private Functions

private extension SignUpViewModel {
    
    func validateID(_ id: String) -> Bool {
        let idRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id)
    }
    
    func validatePassword(_ password: String, _ repassword: String) -> Bool {
        guard password == repassword else { return false }
        let passwordRegex = "(?=.*\\d)(?=.*[a-z])[a-zA-Z\\d]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func validateName(_ userName: String) -> Bool {
        // FIXME: 특수문자 제외 규칙 적용
        return true
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // FIXME: 숫자 규칙 적용
        return true
    }
}
