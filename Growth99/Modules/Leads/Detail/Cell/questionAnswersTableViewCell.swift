//
//  questionAnswersTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

class questionAnswersTableViewCell: UITableViewCell {
    @IBOutlet weak var qutionNameLbi: UILabel!
    @IBOutlet weak var ansLbi: UILabel!
    @IBOutlet weak var editButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
