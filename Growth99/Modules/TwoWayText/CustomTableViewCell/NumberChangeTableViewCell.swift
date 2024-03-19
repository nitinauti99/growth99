//
//  NumberChangeTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/24.
//

import UIKit

class NumberChangeTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelView.layer.cornerRadius = 12
        labelView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
