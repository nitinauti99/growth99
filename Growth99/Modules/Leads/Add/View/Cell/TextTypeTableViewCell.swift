//
//  TextTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class TextTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var textTypeLbi: UILabel!
    @IBOutlet weak var textTypeTextField: UITextView!
    @IBOutlet weak var errorTypeLbi: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textTypeTextField.layer.borderColor = UIColor.gray.cgColor;
        textTypeTextField.layer.borderWidth = 1.0;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
