//
//  EmailTemplateTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

protocol LeadEmailTemplateTableViewCellDelegate: AnyObject {
    func selectEmailTemplate(cell: LeadEmailTemplateTableViewCell)
    func sendEmailTemplateList(cell: LeadEmailTemplateTableViewCell)
}

class LeadEmailTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var emailTextFiled: CustomTextField!
    @IBOutlet weak var emailSendButton: GrowthCutomButton!
    @IBOutlet weak var emailTextFiledButton: UIButton!

    @IBOutlet weak var subView: UIView!

    weak var delegate: LeadEmailTemplateTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    @IBAction func selectEmailTemplate(sender: UIButton) {
        self.delegate?.selectEmailTemplate(cell: self)
    }
    
    @IBAction func sendEmailTemplateList(sender: UIButton) {
        self.delegate?.sendEmailTemplateList(cell: self)
    }
    
}
