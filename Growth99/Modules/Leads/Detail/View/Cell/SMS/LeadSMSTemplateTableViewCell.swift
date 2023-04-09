//
//  SMSTemplateTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

protocol LeadSMSTemplateTableViewCellDelegate: AnyObject {
    func selectSMSTemplate(cell: LeadSMSTemplateTableViewCell)
    func sendSMSTemplateList(cell: LeadSMSTemplateTableViewCell)
}

class LeadSMSTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var smsTextFiled: CustomTextField!
    @IBOutlet weak var smsSendButton: GrowthCutomButton!
    @IBOutlet weak var smsTextFiledButton: UIButton!
    @IBOutlet weak var subView: UIView!

    weak var delegate: LeadSMSTemplateTableViewCellDelegate?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }

    @IBAction func selectSMSTemplate(sender: UIButton) {
        self.delegate?.selectSMSTemplate(cell: self)
    }
    
    @IBAction func sendSMSTemplateList(sender: UIButton) {
        self.delegate?.sendSMSTemplateList(cell: self)

    }
}
