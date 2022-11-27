//
//  ExhibitionDetailViewModel.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import RxSwift
import RxCocoa

final class ExhibitionDetailViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        let exhibition: Driver<Exhibition>
        let isLike: Driver<Bool>
    }
    
    private let exhibition: Exhibition
    
    init(exhibition: Exhibition) {
        self.exhibition = exhibition
    }
    
    func transform(input: Input) -> Output {
        let exhibition = input.viewWillAppear
            .flatMapLatest { _ in
                return Driver<Exhibition>.of(self.exhibition)
            }
        
        let isLike = input.viewWillAppear
            .flatMapLatest { _ in
                // TODO: 현재 사용자가 찜한 전시회인지 확인하는 로직 추가
                return Driver<Bool>.of(.random())
            }
        
        return .init(
            exhibition: exhibition,
            isLike: isLike
        )
    }
}
