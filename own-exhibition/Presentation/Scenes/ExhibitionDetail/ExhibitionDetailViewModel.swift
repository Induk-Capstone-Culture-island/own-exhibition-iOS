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
        
        return .init(exhibition: exhibition)
    }
}
