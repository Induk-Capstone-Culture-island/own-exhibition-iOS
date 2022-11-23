//
//  GeoCoordinate.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import Foundation

/// 위도 경도 좌표 시스템 타입
struct GeoCoordinate {
    
    /// 경도, GPS X 좌표
    let lon: Double
    
    /// 위도, GPS Y 좌표
    let lat: Double
    
    ///  - Parameters:
    ///     - lon: 경도, GPS X 좌표
    ///     - lat: 위도, GPS Y 좌표
    init(lon: Double, lat: Double) {
        self.lon = lon
        self.lat = lat
    }
}
