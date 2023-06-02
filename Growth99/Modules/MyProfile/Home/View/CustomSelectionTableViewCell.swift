//
//  CustomSelectionTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 01/06/23.
//

import UIKit

class CustomSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var selcrtionLBI: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
