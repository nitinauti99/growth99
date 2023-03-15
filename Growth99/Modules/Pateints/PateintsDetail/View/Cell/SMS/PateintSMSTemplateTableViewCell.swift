//
//  PateintSMSTemplateTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 14/03/23.
//

import UIKit

protocol PateintSMSTemplateTableViewCellDelegate: AnyObject {
    func selectSMSTemplate(cell: PateintSMSTemplateTableViewCell)
    func sendSMSTemplateList()
}

class PateintSMSTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var smsTextFiled: CustomTextField!
    @IBOutlet weak var smsSendButton: UIButton!
    @IBOutlet weak var smsTextFiledButton: UIButton!
    @IBOutlet weak var subView: UIView!

    weak var delegate: PateintSMSTemplateTableViewCellDelegate?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.smsSendButton.layer.cornerRadius = 5
        self.smsSendButton.layer.borderWidth = 1
        self.smsSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
    }

    @IBAction func selectSMSTemplate(sender: UIButton) {
        self.delegate?.selectSMSTemplate(cell: self)
    }
    
    @IBAction func sendSMSTemplateList(sender: UIButton) {
        delegate?.sendSMSTemplateList()

    }
}
