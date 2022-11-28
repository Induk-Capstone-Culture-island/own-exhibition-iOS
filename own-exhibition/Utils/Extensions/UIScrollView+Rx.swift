//
//  UIScrollView+Rx.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/28.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    var didScrollToBottom: ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - (self.base.contentInset.top + self.base.contentInset.bottom)
            let space: CGFloat = 100
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = self.base.contentSize.height - visibleHeight - space
            return y >= threshold
        }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ -> Void in }

        return ControlEvent(events: source)
    }
}
