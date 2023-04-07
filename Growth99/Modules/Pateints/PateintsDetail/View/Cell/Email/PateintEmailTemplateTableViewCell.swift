//
//  PateintEmailTemplateTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 14/03/23.
//

import UIKit

protocol PateintEmailTemplateTableViewCellDelegate: AnyObject {
    func selectEmailTemplate(cell: PateintEmailTemplateTableViewCell)
    func sendEmailTemplateList()
}

class PateintEmailTemplateTableViewCell: UITableViewCell {

    @IBOutlet weak var emailTextFiled: CustomTextField!
    @IBOutlet weak var emailSendButton: UIButton!
    @IBOutlet weak var emailTextFiledButton: UIButton!
    @IBOutlet weak var subView: UIView!

    weak var delegate: PateintEmailTemplateTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.emailSendButton.isUserInteractionEnabled = false
    }

    @IBAction func selectEmailTemplate(sender: UIButton) {
        self.delegate?.selectEmailTemplate(cell: self)
    }
    
    @IBAction func sendEmailemplateList(sender: UIButton) {
        delegate?.sendEmailTemplateList()
    }
}
