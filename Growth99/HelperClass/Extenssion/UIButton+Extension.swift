//
//  UIButton+Extension.swift
//  Growth99
//
//  Created by admin on 16/11/22.
//

import Foundation
import UIKit

extension UIButton {

    class func barButtonTarget(target: Any,
                               action: Selector,
                               imageName: String) -> UIBarButtonItem {
        let backButton = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 30,
                                                height: 30))
        backButton.setImage(UIImage(named: imageName), for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let barBackButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(target, action: action, for: .touchUpInside)
        return barBackButtonItem
    }
    
}
