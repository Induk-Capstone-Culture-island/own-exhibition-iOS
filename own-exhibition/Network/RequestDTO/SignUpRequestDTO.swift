//
//  SignUpRequestDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/29.
//

import Foundation

final class SignUpRequestDTO: Encodable {
    
    let name: String
    let email: String
    let password: String
    let passwordConfirmation: String
    let birthday: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case name, email, password
        case passwordConfirmation = "password_confirmation"
        case birthday
        case phone
    }
    
    init(name: String, email: String, password: String, birthday: String, phone: String) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = password
        self.birthday = birthday
        self.phone = phone
    }
}
