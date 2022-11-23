//
//  NetworkError.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/18.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode
    case nonExistentData
}
