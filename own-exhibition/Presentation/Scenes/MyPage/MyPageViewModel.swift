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
        let personalInfo: Driver<PersonalInfo>
        let selectedChangeName: Driver<PersonalInfo>
        let selectedChangeBirth: Driver<PersonalInfo>
        let selectedChangePhoneNumber: Driver<PersonalInfo>
        let selectedChangePassword: Driver<PersonalInfo>
    }
    
    private let coordinator: MyPageCoordinator
    private let personalInfo: PersonalInfo
    
    init(coordinator: MyPageCoordinator, personalInfo: PersonalInfo) {
        self.coordinator = coordinator
        self.personalInfo = personalInfo
    }
    
    func transform(input: Input) -> Output {
        let personalInfos = input.viewWillAppear
            .flatMapLatest { _ in
                return Driver<PersonalInfo>.of(self.personalInfo)
            }
        
        let selectedChangeName = input.selectedChangeName
            .flatMapLatest { _ in
                return Driver<PersonalInfo>.of(self.personalInfo)
            }
            .do(onNext: coordinator.changeInfo)
                
        let selectedChangePhoneNumber = input.selectedChangePhoneNumber
            .flatMapLatest { _ in
                return Driver<PersonalInfo>.of(self.personalInfo)
            }
            .do(onNext: coordinator.changeInfo)
                
        let selectedChangeBirth = input.selectedChangeBirth
            .flatMapLatest { _ in
                return Driver<PersonalInfo>.of(self.personalInfo)
            }
            .do(onNext: coordinator.changeInfo)
        
        let selectedChangePassword = input.selectedChangePassword
            .flatMapLatest { _ in
                return Driver<PersonalInfo>.of(self.personalInfo)
            }
            .do(onNext: coordinator.changePassword)
                
        return .init(
            personalInfo: personalInfos,
            selectedChangeName: selectedChangePassword,
            selectedChangeBirth: selectedChangeName,
            selectedChangePhoneNumber: selectedChangeBirth,
            selectedChangePassword: selectedChangePhoneNumber
        )
    }
}
