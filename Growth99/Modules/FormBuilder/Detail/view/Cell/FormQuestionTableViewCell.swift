//
//  FormQuestionTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 19/02/23.
//

import UIKit

class FormQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionNameTextfield: CustomTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
