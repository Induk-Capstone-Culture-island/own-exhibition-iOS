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
        let exhibitions = BehaviorRelay<[Exhibition]>.init(
            value: [
                .init(
                    title: "A",
                    startDate: .init(),
                    endDate: .init(),
                    location: .init(lat: 1, lon: 1),
                    place: "A",
                    thumbnailUrl: "A",
                    businessHours: "A",
                    description: "A"
                )
            ]
        )
            .asDriver()
        
        return .init(exhibitions: exhibitions)
    }
}
