//
//  CustomSMSTemplateTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

protocol LeadCustomSMSTemplateTableViewCellDelegate: AnyObject {
    func sendCustomSMSTemplateList(cell: LeadCustomSMSTemplateTableViewCell, index: IndexPath)
}

class LeadCustomSMSTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var smsTextView: CustomTextView!
    @IBOutlet weak var smsSendButton: GrowthCutomButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var errorLbi: UILabel!

    var indexPath = IndexPath()
    weak var delegate: LeadCustomSMSTemplateTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func cnfigureCell(index: IndexPath){
        self.errorLbi.isHidden = true
        self.indexPath = index
    }
    
    @IBAction func sendCustomSMSTemplateList(sender: UIButton) {
        delegate?.sendCustomSMSTemplateList(cell: self, index: indexPath)
    }

    

}
