//
//  ViewModelType.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
