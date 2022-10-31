//
//  Exhibition.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import Foundation

struct Exhibition {
    let title: String
    let startDate: Date
    let endDate: Date
    let location: GeoCoordinate
    let place: String
    let thumbnailUrl: String
    let businessHours: String
    let description: String
}

#if DEBUG
extension Exhibition {
    
    /// Debug 용 함수
    static func makeMock() -> Self {
        return .init(
            title: "김꽃님 개인전 - 닿을 수 없는 숨",
            startDate: {
                let startDate: String = "2022.10.04."
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd."
                return formatter.date(from: startDate)!
            }(),
            endDate: {
                let startDate: String = "2022.10.16."
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd."
                return formatter.date(from: startDate)!
            }(),
            location: .init(lat: 37.541, lon: 126.986),
            place: "예술공간 의식주",
            thumbnailUrl: "",
            businessHours: "13:30 ~ 19:00",
            description: "어떤 숨은 시가 되고 어떤 숨은 일기가 되고 또 어떤 숨은 소설이 된다. 이 호흡은 차분하지만 쓸쓸한, 포근하지만 날카로운 어휘로 장면들 사이의 공간을 살며시 감싸고 있다. 김꽃님이 그려내는 장면은 최대한 간결하고 단순하게 하나의 낱말을 툭하고 내뱉는다."
        )
    }
}
#endif
