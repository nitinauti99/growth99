
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
    
    static func barButtonTarget(target: Any,
                               action: Selector,
                               name: String) -> UIBarButtonItem {
        let leftBarButton = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 30,
                                                height: 30))
        leftBarButton.setTitle(name, for: .normal)
        leftBarButton.backgroundColor = UIColor(hexString: "#009EDE")
        leftBarButton.tintColor = .white

        leftBarButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let barLeftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        leftBarButton.addTarget(target, action: action, for: .touchUpInside)
        return barLeftBarButtonItem
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
