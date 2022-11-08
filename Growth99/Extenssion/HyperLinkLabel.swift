//
//  HyperLinkLabel.swift
//  Growth99
//
//  Created by nitin auti on 09/10/22.
//

import Foundation
import UIKit

typealias LinkTapAction = ((String?) -> Void)?

@IBDesignable class HyperLinkLabel: UILabel {
    
    internal var linkTapped: LinkTapAction = .none
    
    private var tapGesture: UITapGestureRecognizer?
    
    @IBInspectable var hyperLink: String = "" {
        didSet {
            updateHyperLinkText()
        }
    }
    
    @IBInspectable var linkColor: UIColor? = UIColor.blue {
        didSet {
            updateHyperLinkText()
        }
    }
    
    @IBInspectable var shouldShowUnderLine: Bool = false {
        didSet {
            updateHyperLinkText()
        }
    }
    
    @objc func updateHyperLinkText(linkAction: LinkTapAction = .none){
        guard let linkColor = self.linkColor, !hyperLink.isEmpty else {
            return
        }
        linkTapped = linkAction
        let lblPropertes = LabelPropertes(LinkColor: linkColor, shouldShowUnderLine: self.shouldShowUnderLine)
        self.applayLinkStyleToText(hyperLink, labelPropertes: lblPropertes)
        addTapAction()
    }
    
    internal func addTapAction(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(taplink(tap:)))
        self.addGestureRecognizer(tap)
        tapGesture?.isEnabled = true
        tapGesture = tap
    }
    
    internal func removeTappAction(){
        if let tap = tapGesture {
            self.removeGestureRecognizer(tap)
        }
        tapGesture?.isEnabled = false
        tapGesture = nil
    }
    
    @objc func taplink(tap: UITapGestureRecognizer){
        if (tap.didTapAttributedTextInLabel(self, inRange: self.getRangeForText(hyperLink))){
            linkTapped?(hyperLink)
        }
    }
}

extension RangeExpression where Bound == String.Index {
    func nsRange<S: StringProtocol>(in string: S) ->NSRange { .init(self, in: string)}
}
