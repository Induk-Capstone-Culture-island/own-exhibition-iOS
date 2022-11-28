//
//  ExhibitionResponseDTO.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/28.
//

import Foundation

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
    
    enum CodingKeys: CodingKey {
        case seq
        case title
        case startDate
        case endDate
        case place
        case realmName
        case area
        case thumbnail
        case gpsX
        case gpsY
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.seq = try container.decode(String.self, forKey: .seq)
        self.title = try container.decode(String.self, forKey: .title)
        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.endDate = try container.decode(String.self, forKey: .endDate)
        if let place = try? container.decode(String.self, forKey: .place) {
            self.place = place
        } else {
            self.place = ""
        }
        self.realmName = try container.decode(String.self, forKey: .realmName)
        if let area = try? container.decode(String.self, forKey: .area) {
            self.area = area
        } else {
            self.area = ""
        }
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        if let gpsX = try? container.decode(String.self, forKey: .gpsX) {
            self.gpsX = gpsX
        } else {
            self.gpsX = ""
        }
        if let gpsY = try? container.decode(String.self, forKey: .gpsY) {
            self.gpsY = gpsY
        } else {
            self.gpsY = ""
        }
    }
}

extension ExhibitionResponseDTO: EntityConvertible {
    
    func toEntity() -> Exhibition {
        return .init(
            title: title,
            startDate: {
                let startDate: String = startDate
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.date(from: startDate)!
            }(),
            endDate: {
                let startDate: String = endDate
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.date(from: startDate)!
            }(),
            location: .init(lon: Double(gpsX) ?? 0, lat: Double(gpsY) ?? 0),
            place: place,
            thumbnailUrl: thumbnail,
            businessHours: "",
            description: ""
        )
    }
}
