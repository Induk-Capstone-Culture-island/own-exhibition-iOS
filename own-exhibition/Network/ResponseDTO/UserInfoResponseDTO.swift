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

final class UserResponseDTO: Decodable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    let updatedAt: String
    let birthday: String

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case birthday
    }
}

extension UserResponseDTO: EntityConvertible {
    
    func toEntity() -> UserInfo {
        return .init(
            // FIXME: 서버에서 비밀번호를 보내주지 않음
            password: "",
            name: name,
            email: email,
            birth: {
                let birthday: String = birthday
                let formatter = DateFormatter()
                // TODO: 서버가 보내주는 형식이랑 비교 확인 필요
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.date(from: birthday)!
            }(),
            // FIXME: 서버에서 전화번호를 보내주지 않음
            phoneNumber: ""
        )
    }
}
