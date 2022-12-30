//
//  MultipleSelectionWithDropDownTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

class MultipleSelectionWithDropDownTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownTypeLbi: UILabel!
    @IBOutlet weak var dropDownTypeTextField: CustomTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
