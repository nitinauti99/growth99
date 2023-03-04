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
    
    func emptyMessage(parentView: UIView, message: String) {
        let messageLBI = UILabel(frame: CGRect(x: 20, y: parentView.frame.height / 2 , width: parentView.frame.width - 20, height: 100))
        messageLBI.textAlignment = .center
        messageLBI.text = message
        parentView.addSubview(messageLBI)
     }
    
}
