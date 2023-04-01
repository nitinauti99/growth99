//
//  GRBarbuttonItem.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    class func createMenu(target: AnyObject, action: Selector) -> UIBarButtonItem {
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "sidemenu"), for: .normal)
        menuButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        menuButton.addTarget(target, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem()
        barButtonItem.customView = menuButton
        return barButtonItem
    }
    
    class func createApplicationLogo(target: AnyObject) -> [UIBarButtonItem] {
        let logoImage = UIImage.init(named: "Logo")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: -40, y: 0, width: 120, height: 25)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        return [negativeSpacer, imageItem]
    }
}

extension UIImageView {
    
    class func navigationBarLogo() -> UIImageView {
        let logoImage = UIImage.init(named: "Logo")
        let logoImageView = UIImageView(image: logoImage)
        return logoImageView
    }
    
}
