//
//  InputTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class InputTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var inputeTypeLbi: UILabel!
    @IBOutlet weak var inputeTypeTextField: CustomTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
