//
//  ExhibitionRepository.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/10/31.
//

import RxSwift

final class ExhibitionRepository {
    
    func getExhibitions() -> Observable<[Exhibition]> {
        return .of([
            .makeMock(),
            .makeMock(),
            .makeMock(),
            .makeMock(),
            .makeMock(),
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
        ])
    }
}
