//
//  GeoCoordinate.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import Foundation

/// 위도 경도 좌표 시스템 타입
struct GeoCoordinate {
    
    /// 위도
    let lat: Double
    
    /// 경도
    let lon: Double
    
    ///  - Parameters:
    ///     - lat: 위도
    ///     - lon: 경도
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}
