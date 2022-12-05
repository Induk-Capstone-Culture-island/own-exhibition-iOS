//
//  WishResponseDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/12/05.
//

import Foundation

final class WishResponseDTO: Decodable {
    let id: Int
    let userID: Int
    let exhibitionID: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case exhibitionID = "exhibition_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
