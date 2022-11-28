//
//  ExhibitionPageResponseDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/18.
//

import Foundation

final class ExhibitionPageResponseDTO: Decodable {
    let currentPage: Int
    let lastPage: Int
    let data: [ExhibitionResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case data
    }
}

extension ExhibitionPageResponseDTO {
    
    func toEntity() -> ExhibitionPage {
        return .init(
            currentPage: currentPage,
            lastPage: lastPage,
            exhibitions: data.map { $0.toEntity() }
        )
    }
}
