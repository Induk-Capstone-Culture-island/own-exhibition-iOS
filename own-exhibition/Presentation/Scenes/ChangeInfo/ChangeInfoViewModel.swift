//
//  ChangeInfoViewModel.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import RxSwift
import RxCocoa

final class ChangeInfoViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        let personalInfo: Driver<PersonalInfo>
    }
    
    private let personalInfo: PersonalInfo
    
    init(personalInfo: PersonalInfo){
        self.personalInfo = personalInfo
    }
    
    func transform(input: Input) -> Output {
        let personalInfo = input.viewWillAppear
            .flatMapLatest{ _ in
                return Driver<PersonalInfo>.of(self.personalInfo)
            }
        return .init(personalInfo: personalInfo)
    }
}
