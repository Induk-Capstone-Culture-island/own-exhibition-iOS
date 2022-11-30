//
//  Token+Mock.swift
//  own-exhibitionTests
//
//  Created by Jaewon Yun on 2022/11/30.
//

import Foundation
@testable import own_exhibition

extension Token {
    
    static func makeMock() -> Self {
        return .init(id: "test1234@naver.com", value: "testToken")
    }
}
