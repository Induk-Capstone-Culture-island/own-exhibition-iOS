//
//  UserInfoResponseDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/29.
//

import Foundation

final class UserInfoResponseDTO: Decodable {
    let user: UserResponseDTO
    let message: String
    let status: String
}
