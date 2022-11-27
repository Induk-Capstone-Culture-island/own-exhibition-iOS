//
//  ExhibitionSearchBar.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/26.
//

import UIKit

final class ExhibitionSearchBar: UISearchBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchBarStyle = .minimal
        self.placeholder = "전시회 제목, 지역"
    }
}
