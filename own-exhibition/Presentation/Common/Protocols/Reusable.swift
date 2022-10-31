//
//  Reusable.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/21.
//

import UIKit

protocol Reusable {
    static var id: String { get }
}

extension UITableViewCell: Reusable {
    static var id: String {
        String.init(describing: self)
    }
}
