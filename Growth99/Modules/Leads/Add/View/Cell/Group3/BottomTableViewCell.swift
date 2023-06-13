//
//  BottomTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 13/06/23.
//

import UIKit

protocol BottomTableViewCellProtocol: AnyObject {
    func submitButtonPressed()
    func cancelButtonPressed()
}

class BottomTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!

    var delegate: BottomTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.submitButton.roundCorners(corners: [.allCorners], radius: 10)
        self.CancelButton.roundCorners(corners: [.allCorners], radius: 10)

    }

    
    @IBAction func submitButtonPressed(sender: UIButton) {
        delegate?.submitButtonPressed()
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        delegate?.cancelButtonPressed()

    }
    
}
