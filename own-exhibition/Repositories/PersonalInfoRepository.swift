//
//  MyPageRepository.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/11/13.
//

import RxSwift

final class PersonalInfoRepository {
    
    func getPeronalInfo() -> Observable<PersonalInfo> {
        return .of(
            .makemock()
        )
    }
}
