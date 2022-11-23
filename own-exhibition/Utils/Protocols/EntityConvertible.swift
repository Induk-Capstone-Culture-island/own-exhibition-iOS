//
//  EntityConvertible.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/18.
//

import Foundation

protocol EntityConvertible {
    associatedtype EntityType
    
    func toEntity() -> EntityType
}
