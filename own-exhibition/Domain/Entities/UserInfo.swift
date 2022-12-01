//
//  SignUp.swift
//  own-exhibition
//
//  Created by junho on 2022/11/08.
//

import Foundation

struct UserInfo {
    let password: String
    let name: String
    let email: String
    let birth: Date
    let phoneNumber: String
}

#if DEBUG
extension UserInfo {
    /// Debug 용 함수
    static func makemock() -> Self {
        return .init(
            password: "pw",
            name: "name",
            email: "email@aa",
            birth: .now,
            phoneNumber: "aa"
        )
    }
}
#endif
