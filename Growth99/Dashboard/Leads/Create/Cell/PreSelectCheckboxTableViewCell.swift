//
//  PreSelectCheckboxTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

class PreSelectCheckboxTableViewCell: UITableViewCell {

    @IBOutlet weak var preSelectCheckbox: UILabel!
    @IBOutlet weak var preSelectedCheckBoxButton: PassableUIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preSelectedCheckBoxButton.isSelected = true
        preSelectedCheckBoxButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func buttonAction(sender: UIButton!){
        if sender.isSelected {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
}
