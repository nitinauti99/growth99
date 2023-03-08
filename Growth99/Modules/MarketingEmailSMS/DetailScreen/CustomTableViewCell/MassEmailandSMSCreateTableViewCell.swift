//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSCreateCellDelegate: AnyObject {
    func nextButtonCreate(cell: MassEmailandSMSCreateTableViewCell, index: IndexPath)
}

class MassEmailandSMSCreateTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!

    @IBOutlet private weak var smsBtn: UIButton!
    @IBOutlet private weak var emailBtn: UIButton!
    
    @IBOutlet weak var networkSelectonSMSButton: UIButton!
    @IBOutlet weak var networkViewSMS: UIView!
    @IBOutlet weak var selectNetworkSMSTextLabel: UILabel!
    
    @IBOutlet weak var networkSelectonEmailButton: UIButton!
    @IBOutlet weak var networkViewEmail: UIView!
    @IBOutlet weak var selectNetworkEmailTextLabel: UILabel!

    weak var delegate: MassEmailandSMSCreateCellDelegate?
    var indexPath = IndexPath()
    var networkTypeSelected: String = "sms"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
        networkViewEmail.layer.cornerRadius = 4.5
        networkViewEmail.layer.borderWidth = 1
        networkViewEmail.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        networkViewSMS.layer.cornerRadius = 4.5
        networkViewSMS.layer.borderWidth = 1
        networkViewSMS.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonCreate(cell: self, index: indexPath)
    }

    @IBAction func smsButtonAction(sender: UIButton) {
        smsBtn.isSelected = !smsBtn.isSelected
        networkViewEmail.isHidden = true
        networkViewSMS.isHidden = false
        networkTypeSelected = "sms"
        emailBtn.isSelected = false
    }
    
    @IBAction func emailButtonAction(sender: UIButton) {
        emailBtn.isSelected = !emailBtn.isSelected
        networkViewEmail.isHidden = false
        networkViewSMS.isHidden = true
        networkTypeSelected = "email"
        smsBtn.isSelected = false
    }
}
