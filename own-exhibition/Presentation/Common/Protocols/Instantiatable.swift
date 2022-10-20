//
//  Instantiatable.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import UIKit

protocol Instantiatable: UIViewController {
    static func instantiate(withStoryboardName storyboardName: String) -> Self
}

extension UIViewController: Instantiatable {
    static func instantiate(withStoryboardName storyboardName: String) -> Self {
        let storyboardID = String(describing: self)
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardID) as! Self
    }
}
