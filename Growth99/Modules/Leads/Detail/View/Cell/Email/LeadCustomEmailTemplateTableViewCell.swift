//
//  CustomEmailTemplateTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

protocol LeadCustomEmailTemplateTableViewCellDelegate: AnyObject {
    func sendCustomEmailTemplateList(cell: LeadCustomEmailTemplateTableViewCell, index: IndexPath)
}

class LeadCustomEmailTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var emailTextFiled: CustomTextField!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var emailSendButton: GrowthCutomButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var errorLbi: UILabel!

    var indexPath = IndexPath()
    weak var delegate: LeadCustomEmailTemplateTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }

    func cnfigureCell(index: IndexPath){
        self.errorLbi.isHidden = true
        self.indexPath = index
    }
    
    @IBAction func sendCustomEmailTemplateList(sender: UIButton) {
        delegate?.sendCustomEmailTemplateList(cell: self, index: indexPath)
    }
}
