//
//  PateintCustomSMSTemplateTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 14/03/23.
//

import UIKit

protocol PateintCustomSMSTemplateTableViewCellDelegate: AnyObject {
    func sendCustomSMSTemplateList(cell: PateintCustomSMSTemplateTableViewCell, index: IndexPath)
}

class PateintCustomSMSTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var smsTextView: UITextView!
    @IBOutlet weak var smsSendButton: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var errorLbi: UILabel!

    weak var delegate: PateintCustomSMSTemplateTableViewCellDelegate?
    
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.smsSendButton.layer.cornerRadius = 5
        self.smsSendButton.layer.borderWidth = 1
        self.smsSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
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
