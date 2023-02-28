//
//  EmailTemplateTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

class EmailTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var emailTextFiled: CustomTextField!
    @IBOutlet weak var emailSendButton: UIButton!
    @IBOutlet weak var emailTextFiledButton: UIButton!

    @IBOutlet weak var subView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
