//
//  ViewExtension.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation
import UIKit
import QuartzCore

public extension UIView {
    
    func dropShadow(color: UIColor = UIColor.borderColor, opacity: Float = 0.5, offset: CGSize = CGSize.zero, redius: CGFloat = 4, scale: Bool = true){
        self.layer.masksToBounds = false
        let cgColor: CGColor = color.cgColor
        self.layer.borderColor = cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = redius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func createBorderForView(color: UIColor = UIColor.borderColor, redius: CGFloat = 5, width: CGFloat = 2){
        self.layer.borderWidth = width
        self.layer.cornerRadius = redius
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        let cgColor: CGColor = color.cgColor
        self.layer.borderColor = cgColor
    }
    
    func addBottomShadow(color: UIColor = UIColor.borderColor,offset: CGSize = CGSize(width: 0, height: 3), redius: CGFloat = 4, opacity: Float = 0.5){
        self.layoutIfNeeded()
        self.layer.masksToBounds = false
        let cgColor: CGColor = color.cgColor
        self.layer.shadowColor = cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = redius
    }
    
    func addTopShadow(color: UIColor = UIColor.borderColor,offset: CGSize = CGSize(width: 0, height: -3), redius: CGFloat = 4){
        self.layoutIfNeeded()
        self.layer.masksToBounds = false
        let cgColor: CGColor = color.cgColor
        self.layer.shadowColor = cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = redius
    }
    
}
