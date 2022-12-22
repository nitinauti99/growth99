//
//  PassableUIButton.swift
//  Growth99
//
//  Created by nitin auti on 22/12/22.
//

import Foundation
import UIKit

class PassableUIButton: UIButton{
    var params: Dictionary<Int, Any>
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}
