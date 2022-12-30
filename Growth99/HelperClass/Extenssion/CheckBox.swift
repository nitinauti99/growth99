//
//  CheckBox.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "tickdefault")! as UIImage
    let uncheckedImage = UIImage(named: "tickselected")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
