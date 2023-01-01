//
//  CustomSMSTemplateTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

class CustomSMSTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var smsTextView: UITextView!
    @IBOutlet weak var smsSendButton: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var errorLbi: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        smsTextView.layer.borderWidth = 1
        smsTextView.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
        smsTextView.layer.cornerRadius = 5
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
