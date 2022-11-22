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
        let signUp: Driver<Void>
    }
    
    private let signUpCoordinator: SignUpCoordinator
    
    init(signUpCoordinator: SignUpCoordinator) {
        self.signUpCoordinator = signUpCoordinator
    }
    
    func transform(input: Input) -> Output {
        // FIXME: 회원가입 처리
        let signUp = Driver<Void>.empty()
            .do(onNext: {  })
        
        return .init(signUp: signUp)
    }
}
