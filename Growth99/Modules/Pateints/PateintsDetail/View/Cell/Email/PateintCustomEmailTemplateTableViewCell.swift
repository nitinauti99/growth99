//
//  PateintCustomEmailTemplateTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 14/03/23.
//

import UIKit

protocol PateintCustomEmailTemplateTableViewCellDelegate: AnyObject {
    func sendCustomEmailTemplateList(cell: PateintCustomEmailTemplateTableViewCell)
}

class PateintCustomEmailTemplateTableViewCell: UITableViewCell {
    @IBOutlet weak var emailTextFiled: CustomTextField!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var emailSendButton: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var errorLbi: UILabel!

    weak var delegate: PateintCustomEmailTemplateTableViewCellDelegate?

    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.emailSendButton.layer.cornerRadius = 5
        self.emailSendButton.layer.borderWidth = 1
        self.emailSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func cnfigureCell(index: IndexPath){
        self.errorLbi.isHidden = true
        self.indexPath = index
    }
    
    @IBAction func sendCustomEmailTemplateList(sender: UIButton) {
        delegate?.sendCustomEmailTemplateList(cell: self)
    }
    
}
