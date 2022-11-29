//
//  LoginRequestDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/27.
//

import Foundation

final class LoginRequestDTO: Encodable {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
