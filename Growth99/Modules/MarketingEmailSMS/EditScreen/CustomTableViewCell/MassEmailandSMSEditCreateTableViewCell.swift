//
//  MassEmailandSMSEditDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSEditCreateCellDelegate: AnyObject {
    func nextButtonCreate(cell: MassEmailandSMSEditCreateTableViewCell, index: IndexPath, networkType: String)
    func smsButtonClick(cell: MassEmailandSMSEditCreateTableViewCell)
    func emailButtonClick(cell: MassEmailandSMSEditCreateTableViewCell)
    func smsNetworkButtonSelected(cell: MassEmailandSMSEditCreateTableViewCell, index: IndexPath, buttonSender: UIButton, networkType: String)
    func emailNetworkButtonSelected(cell: MassEmailandSMSEditCreateTableViewCell, index: IndexPath, buttonSender: UIButton, networkType: String)
}

class MassEmailandSMSEditCreateTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var smsEmailCountLabel: UILabel!
    @IBOutlet weak var selectNetworkButton: UIButton!
    @IBOutlet weak var selectNetworkTextField: CustomTextField!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: MassEmailandSMSEditCreateCellDelegate?
    var indexPath = IndexPath()
    var networkTypeSelected: String = "sms"
    let radioController: RadioButtonController = RadioButtonController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        radioController.buttonsArray = [smsBtn, emailBtn]
        radioController.defaultButton = smsBtn
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonCreate(cell: self, index: indexPath, networkType: networkTypeSelected)
    }
    
    @IBAction func smsButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        networkTypeSelected = "sms"
        selectNetworkTextField.text = ""
        self.delegate?.smsButtonClick(cell: self)
    }
    
    @IBAction func emailButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        networkTypeSelected = "email"
        selectNetworkTextField.text = ""
        self.delegate?.emailButtonClick(cell: self)
    }
    
    @IBAction func selectNetworkTypeButton(sender: UIButton) {
        if networkTypeSelected == "sms" {
            selectNetworkTextField.text = ""
            self.delegate?.smsNetworkButtonSelected(cell: self, index: indexPath, buttonSender: sender, networkType: networkTypeSelected)
        } else {
            selectNetworkTextField.text = ""
            self.delegate?.emailNetworkButtonSelected(cell: self, index: indexPath, buttonSender: sender, networkType: networkTypeSelected)
        }
    }
}
