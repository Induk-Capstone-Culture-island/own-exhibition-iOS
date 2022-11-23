//
//  DefaultBackBarButtonItem.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/22.
//

import UIKit

final class DefaultBackBarButtonItem: UIBarButtonItem {
    
    override init() {
        super.init()
        self.title = nil
        self.tintColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
