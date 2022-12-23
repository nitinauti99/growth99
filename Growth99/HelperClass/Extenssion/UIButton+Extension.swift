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

extension UIButton {
    private func actionHandler(action:(() -> Void)? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    func actionHandler(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}
