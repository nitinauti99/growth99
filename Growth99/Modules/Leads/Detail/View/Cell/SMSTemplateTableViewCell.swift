//
//  SMSTemplateTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

class SMSTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var smsTextFiled: CustomTextField!
    @IBOutlet weak var smsSendButton: UIButton!
    @IBOutlet weak var smsTextFiledButton: UIButton!

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
