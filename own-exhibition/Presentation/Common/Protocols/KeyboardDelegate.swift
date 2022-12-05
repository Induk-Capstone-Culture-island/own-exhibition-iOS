//
//  KeyboardDelegate.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/12/05.
//

import UIKit

@objc protocol KeyboardDelegate where Self: UIViewController {
    
    /// 키보드가 보여질 때 호출됩니다.
    ///
    /// - Parameter notification: 보여지는 키보드에 대한 정보가 담긴 객체
    @objc func keyboardWillShow(_ notification: Notification)
    
    /// 키보드가 사라질 때 호출됩니다.
    ///
    /// - Parameter notification: 사라지는 키보드에 대한 정보가 담긴 객체
    @objc func keyboardWillHide(_ notification: Notification)
}

extension KeyboardDelegate {
    
    func performKeyboardDelegate() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}
