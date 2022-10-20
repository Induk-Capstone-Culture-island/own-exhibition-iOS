//
//  ExhibitionItemViewModel.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/21.
//

import UIKit

/// 담당 Cell 을 보여주기 위해 필요한 데이터 모음
struct ExhibitionItemViewModel {
    
    /// Detail 로 화면 전환 시 넘겨줄 데이터
    let exhibition: Exhibition
    
    var title: String {
        exhibition.title
    }
    
    var period: String {
        // FIXME: 임시 데이터
        "2022.10.01. ~ 2022.10.09."
    }
    
    var place: String {
        exhibition.place
    }
    
    var thumbnail: UIImage {
        guard
            let imageUrl = URL.init(string: exhibition.thumbnailUrl),
            let imageData = try? Data.init(contentsOf: imageUrl),
            let thumbnail = UIImage.init(data: imageData)
        else {
            // FIXME: 기본 썸네일 이미지 반환
            return UIImage.init()
        }
        
        return thumbnail
    }
    
    var description: String {
        exhibition.description
    }
}
