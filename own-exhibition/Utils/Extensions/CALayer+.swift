//
//  CALayer+.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/08.
//

import UIKit

extension CALayer {
    
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: width)
                break
            case UIRectEdge.bottom:
                print(self.frame.width)
                print(self.frame.height)
                border.frame = CGRect.init(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: self.frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
