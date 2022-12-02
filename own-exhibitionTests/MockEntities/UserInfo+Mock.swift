//
//  UserInfo+Mock.swift
//  own-exhibitionTests
//
//  Created by Jaewon Yun on 2022/11/30.
//

import Foundation
@testable import own_exhibition

extension UserInfo {
    
    static func makeMock() -> Self {
        return .init(
            password: "test1234",
            name: "홍길동",
            email: "test1234@naver.com",
            birth: .now,
            phoneNumber: "010-1234-1234"
        )
    }
}
