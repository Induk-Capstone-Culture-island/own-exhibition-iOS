//
//  SignUpResponseDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/29.
//

import Foundation

final class SignUpResponseDTO: Decodable {
    
    let user: UserResponseDTO
    let message: String
    let status: String
    let token: String
}
