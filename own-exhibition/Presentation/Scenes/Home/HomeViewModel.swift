//
//  HomeViewModel.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let exhibitions: Driver<[Exhibition]>
    }
    
    func transform(input: Input) -> Output {
#if DEBUG
        let exhibitions = BehaviorRelay<[Exhibition]>.init(
            value: [
                .makeMock(),
                .makeMock(),
                .makeMock(),
                .makeMock(),
                .makeMock(),
                .makeMock(),
                .makeMock(),
                .makeMock(),
                .makeMock(),
                .makeMock()
            ]
        )
            .asDriver()
#elseif RELEASE
        let exhibitions = BehaviorRelay<[Exhibition]>.init(value: [])
            .asDriver()
#endif
        return .init(exhibitions: exhibitions)
    }
}
