//
//  UITextFieldExtension.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation
import UIKit

@IBDesignable
open class CustomTextField: UITextField {

    fileprivate var lblError: UILabel = UILabel()
    fileprivate let paddingX: CGFloat = 5.0
    fileprivate let paddingHeight:CGFloat = 0
    fileprivate var borderLayer:CALayer = CALayer()
    public var dtLayer:CALayer = CALayer()
    public var borderWidth: CGFloat = 0.5{
        didSet{
            let borderStyle = dtborderStyle;
            dtborderStyle = borderStyle
        }
    }

    public var dtborderStyle:DTBorderStyle = .rounded {
        didSet{
            borderLayer.removeFromSuperlayer()
            switch dtborderStyle {
            case .none:
                dtLayer.cornerRadius        = 0.0
                dtLayer.borderWidth         = 0.0
            case .rounded:
                dtLayer.cornerRadius        = 4.5
                dtLayer.borderWidth         = borderWidth
                dtLayer.borderColor         = borderColor.cgColor
            case .sqare:
                dtLayer.cornerRadius        = 0.0
                dtLayer.borderWidth         = borderWidth
                dtLayer.borderColor         = borderColor.cgColor
            case .bottom,.left,.right,.top:
                dtLayer.cornerRadius        = 0.0
                dtLayer.borderWidth         = 0.0
                borderLayer.backgroundColor = borderColor.cgColor
                if dtborderStyle == .bottom {
                    borderLayer.frame = CGRect(x: 0, y: dtLayer.bounds.size.height - borderWidth, width: dtLayer.bounds.size.width, height: borderWidth)
                }else if dtborderStyle == .left {
                    borderLayer.frame = CGRect(x: 0, y: 0, width: borderWidth, height: dtLayer.bounds.size.height)
                }else if dtborderStyle == .right{
                    borderLayer.frame = CGRect(x: dtLayer.bounds.size.width - borderWidth, y: 0, width: borderWidth, height: dtLayer.bounds.size.height)
                }else{
                    borderLayer.frame = CGRect(x: 0, y: 0, width: dtLayer.bounds.size.width, height: borderWidth)
                }
                dtLayer.addSublayer(borderLayer)
            }
        }
    }
    
    public var errorMessage:String = ""{
        didSet{ lblError.text = errorMessage }
    }
    
    public var animateFloatPlaceholder:Bool = true
    public var hideErrorWhenEditing:Bool   = true
    
    public var errorFont = UIFont.systemFont(ofSize: 11.0){
        didSet{
            lblError.font = errorFont
            invalidateIntrinsicContentSize()
        }
    }
    
    public var errorTextColor = UIColor.red {
        didSet{
            lblError.textColor = errorTextColor
        }
    }
    
    public var paddingYFloatLabel:CGFloat = 3.0 {
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYErrorLabel:CGFloat = 3.0 {
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    @IBInspectable public var borderColor:UIColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0){
        didSet{
            switch dtborderStyle {
            case .none,.rounded,.sqare:
                dtLayer.borderColor = borderColor.cgColor
            case .bottom,.right,.top,.left:
                borderLayer.backgroundColor = borderColor.cgColor
            }
        }
    }
    
    public var canShowBorder:Bool = true {
        didSet{
            switch dtborderStyle {
            case .none,.rounded,.sqare:
                dtLayer.isHidden = !canShowBorder
            case .bottom,.right,.top,.left:
                borderLayer.isHidden = !canShowBorder
            }
        }
    }
    
    public var placeholderColor:UIColor? {
        didSet{
            guard let color = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    fileprivate var x:CGFloat {
        if let leftView = leftView {
            return leftView.frame.origin.x + leftView.bounds.size.width - paddingX
        }
        return paddingX
    }
    
    fileprivate var fontHeight:CGFloat{
        return ceil(font!.lineHeight)
    }
    
    fileprivate var dtLayerHeight:CGFloat{
        return bounds.height
       // return showErrorLabel ? floor(bounds.height - lblError.bounds.size.height - paddingYErrorLabel) : bounds.height
    }
 
    fileprivate var placeholderFinal:String{
        if let attributed = attributedPlaceholder { return attributed.string }
        return placeholder ?? " "
    }
    
    fileprivate var isFloatLabelShowing:Bool = false
    
    fileprivate var showErrorLabel:Bool = false{
        didSet{
            
            guard showErrorLabel != oldValue else { return }
            
            guard showErrorLabel else {
                hideErrorMessage()
                return
            }
            
            guard !errorMessage.isEmptyStr else { return }
            showErrorMessage()
        }
    }
    
    override public var borderStyle: UITextField.BorderStyle{
        didSet{
            guard borderStyle != oldValue else { return }
            borderStyle = .none
        }
    }
    
    public override var textAlignment: NSTextAlignment{
        didSet{ setNeedsLayout() }
    }
    
    public override var text: String?{
        didSet{ self.textFieldTextChanged() }
    }
    
    override public var placeholder: String?{
        didSet{
            
            guard let color = placeholderColor else {
                return
            }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func showError(message:String? = nil) {
        if let msg = message { errorMessage = msg }
        showErrorLabel = true
    }
    
    public func hideError()  {
        showErrorLabel = false
    }

    fileprivate func SetupErroLabelFrame() {
        lblError.frame              = CGRect.zero
        lblError.font               = errorFont
        lblError.textColor          = errorTextColor
        lblError.numberOfLines      = 0
        lblError.isHidden           = true
        
        addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        
        addSubview(lblError)
    }
    
    fileprivate func commonInit() {
       // dtborderStyle               = .rounded
        dtLayer.backgroundColor     = UIColor.white.cgColor
        SetupErroLabelFrame()
        layer.insertSublayer(dtLayer, at: 0)
    }
    
    fileprivate func showErrorMessage(){
        lblError.text = errorMessage
        lblError.isHidden = false
        let boundWithPadding = CGSize(width: bounds.width - (paddingX * 2), height: bounds.height)
        lblError.frame = CGRect(x: paddingX, y: 0, width: boundWithPadding.width, height: boundWithPadding.height)
        lblError.sizeToFit()
    }
    
    func setErrorLabelAlignment() {
        var newFrame = lblError.frame
        
        if textAlignment == .right {
            newFrame.origin.x = bounds.width - paddingX - newFrame.size.width
        }else if textAlignment == .left {
            newFrame.origin.x = paddingX
        }else if textAlignment == .center{
            newFrame.origin.x = (bounds.width / 2.0) - (newFrame.size.width / 2.0)
        }else if textAlignment == .natural{
            
            if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft{
                newFrame.origin.x = bounds.width - paddingX - newFrame.size.width
            }
        }
        
        lblError.frame = newFrame
    }
    
    fileprivate func hideErrorMessage(){
        lblError.text = ""
        lblError.isHidden = true
        lblError.frame = CGRect.zero
        invalidateIntrinsicContentSize()
    }
 
    fileprivate func insetRectForEmptyBounds(rect:CGRect) -> CGRect{
        let newX = x
        guard showErrorLabel else { return CGRect(x: newX, y: 0, width: rect.width - newX - paddingX, height: rect.height) }
        
        let topInset = (rect.size.height - lblError.bounds.size.height - paddingYErrorLabel - fontHeight) / 2.0
        let textY = topInset - ((rect.height - fontHeight) / 2.0)
        
        return CGRect(x: newX, y: floor(textY), width: rect.size.width - newX - paddingX, height: rect.size.height)
    }

    @objc fileprivate func textFieldTextChanged(){
        guard hideErrorWhenEditing && showErrorLabel else { return }
        showErrorLabel = false
    }
    
    override public var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        
        let textFieldIntrinsicContentSize = super.intrinsicContentSize
        
        if showErrorLabel {
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + paddingYErrorLabel + lblError.bounds.size.height + paddingHeight)
        }else{
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + paddingHeight)
        }
    }

    fileprivate func insetForSideView(forBounds bounds: CGRect) -> CGRect{
        var rect = bounds
        rect.origin.y = 0
        rect.size.height = dtLayerHeight
        return rect
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = (dtLayerHeight - rect.size.height) / 2
        return rect
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        dtLayer.frame = CGRect(x: bounds.origin.x - 10,
                               y: bounds.origin.y,
                               width: bounds.width,
                               height: bounds.height)
        let borderStype = dtborderStyle
        dtborderStyle = borderStype
        CATransaction.commit()
        
        if showErrorLabel {
            var lblErrorFrame = lblError.frame
            lblErrorFrame.origin.y = dtLayer.frame.origin.y + dtLayer.frame.size.height + paddingYErrorLabel
            lblError.frame = lblErrorFrame
        }
        setErrorLabelAlignment()
    }
}

public extension String {
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}

public enum DTBorderStyle{
    case none
    case rounded
    case sqare
    case top
    case bottom
    case left
    case right
}
