//
//  YesNoTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class YesNoTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var yesNoTypeLbi: UILabel!
    @IBOutlet weak var yesTypeButton: PassableUIButton!
    @IBOutlet weak var NoTypeButton: PassableUIButton!
    var buttons = [UIButton]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttons.append(yesTypeButton)
        buttons.append(NoTypeButton)
        yesTypeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        NoTypeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func buttonAction(sender: UIButton!){
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
    }
}
