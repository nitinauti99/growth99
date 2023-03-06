//
//  UITextViewExtenssion.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

@IBDesignable
class CustomTextView: UITextView {

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
}
