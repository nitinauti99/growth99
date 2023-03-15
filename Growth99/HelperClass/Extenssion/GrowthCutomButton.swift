//
//  PassableUIButton.swift
//  Growth99
//
//  Created by nitin auti on 22/12/22.
//

import Foundation
import UIKit

class GrowthCutomButton: UIButton {
   
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
