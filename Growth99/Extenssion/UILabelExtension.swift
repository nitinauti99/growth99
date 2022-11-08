//
//  UILabelExtension.swift
//  Growth99
//
//  Created by nitin auti on 09/10/22.
//

import UIKit

extension UILabel {
    
    @objc func getRangeForText(_ rangeText: String) -> NSRange {
        var textRange = NSRange()
        if let plainText = self.attributedText, let range = plainText.string.range(of: rangeText){
            let startPos = plainText.string.distance(from: plainText.string.startIndex, to: range.lowerBound)
            textRange = NSRange(location: startPos, length: rangeText.count)
        }
        return textRange
    }
    
    func applayLinkStyleToText(_ LinkText: String, labelPropertes: LabelPropertes) {
        if let plainText = self.attributedText?.string {
            let StyledText = NSMutableAttributedString(string: plainText)
            let linkAttribute = [NSAttributedString.Key.foregroundColor : labelPropertes.LinkColor ?? .blue, NSAttributedString.Key.font : self.font ?? 14, .underlineStyle: (labelPropertes.shouldShowUnderLine ? 1.0:0.0) ] as [NSAttributedString.Key : Any]
            let attribute = [NSAttributedString.Key.foregroundColor : self.textColor ?? .blue, NSAttributedString.Key.font : self.font ?? 14] as [NSAttributedString.Key : Any]
            StyledText.setAttributes(attribute, range: NSRange(location: 0, length: StyledText.string.count))
            self.text = nil
            self.textColor = nil
            if let range = plainText.range(of: LinkText) {
                let startPos = plainText.distance(from: plainText.startIndex, to: range.lowerBound)
                StyledText.setAttributes(linkAttribute, range: NSRange(location: startPos, length: LinkText.count))
                self.attributedText = StyledText
            }
        }
    }
}

struct LabelPropertes {
    var LinkColor: UIColor?
    var shouldShowUnderLine = false
}
