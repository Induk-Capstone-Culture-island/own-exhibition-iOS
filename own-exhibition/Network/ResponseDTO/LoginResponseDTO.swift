//
//  LoginResponseDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/27.
//

import Foundation

final class LoginResponseDTO: Decodable {
    let token: String
    let message: String
    let status: String
}
