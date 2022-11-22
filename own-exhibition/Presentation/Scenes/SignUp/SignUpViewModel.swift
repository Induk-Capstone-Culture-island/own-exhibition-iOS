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
        
    }
    
    struct Output {
        
    }
    
    private let signUpCoordinator: SignUpCoordinator
    
    init(signUpCoordinator: SignUpCoordinator) {
        self.signUpCoordinator = signUpCoordinator
    }
    
    func transform(input: Input) -> Output {
        return .init()
    }
}
