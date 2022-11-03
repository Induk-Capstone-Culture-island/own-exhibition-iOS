//
//  ExhibitionDetailViewModel.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/01.
//

import RxSwift

final class ExhibitionDetailViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let exhibition: Exhibition
    
    init(exhibition: Exhibition) {
        self.exhibition = exhibition
    }
    
    func transform(input: Input) -> Output {
        return .init()
    }
}
