//
//  UIViewController+Extension.swift
//  Growth99
//
//  Created by admin on 16/11/22.
//

import Foundation
import UIKit

extension UIViewController {

    static func loadStoryboard<T: UIViewController>(_ storyboardName: String, _ identifier: String) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            return viewController
        }
        return nil
    }
}
