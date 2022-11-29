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
        let userInfo: Driver<UserInfo>
    }
    
    private let userInfo: UserInfo
    
    init(userInfo: UserInfo){
        self.userInfo = userInfo
    }
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewWillAppear
            .flatMapLatest{ _ in
                return Driver<UserInfo>.of(self.userInfo)
            }
        return .init(userInfo: userInfo)
    }
}
