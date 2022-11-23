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
        let personalInfo: Driver<PersonalInfo>
        let selectedChangeInfo: Driver<PersonalInfo>
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
        
        let selectedChangeInfo = input.selection
            .flatMapLatest { _ in
                return Driver<PersonalInfo>.of(self.personalInfo)
            }
            .do(onNext: coordinator.changeInfo)
                
        return .init(
            personalInfo: personalInfos,
            selectedChangeInfo: selectedChangeInfo
        )
    }
}
