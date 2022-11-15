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
        
    }
    
    struct Output {
        
    }
    
    private let myPageCoordinator: MyPageCoordinator
    
    init(myPageCoordinator: MyPageCoordinator) {
        self.myPageCoordinator = myPageCoordinator
    }
    
    func transform(input: Input) -> Output {
        return .init()
    }
}
