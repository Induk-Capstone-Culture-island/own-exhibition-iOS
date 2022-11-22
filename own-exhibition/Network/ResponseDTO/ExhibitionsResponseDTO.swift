//
//  ExhibitionsResponseDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/18.
//

import Foundation

final class ExhibitionsResponseDTO: Decodable {
    let data: [ExhibitionResponseDTO]
}

final class ExhibitionResponseDTO: Decodable {
    let seq: String
    let title: String
    let startDate: String
    let endDate: String
    let place: String
    let realmName: String
    let area: String
    let thumbnail: String
    let gpsX, gpsY: String
}

extension ExhibitionResponseDTO: EntityConvertible {
    
    func toEntity() -> Exhibition {
        return .init(
            title: title,
            startDate: {
                let startDate: String = startDate
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                return formatter.date(from: startDate)!
            }(),
            endDate: {
                let startDate: String = endDate
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                return formatter.date(from: startDate)!
            }(),
            location: .init(lat: Double(gpsX) ?? 0, lon: Double(gpsY) ?? 0),
            place: place,
            thumbnailUrl: thumbnail,
            businessHours: "",
            description: ""
        )
    }
}
