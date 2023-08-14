//
//  TriggerDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerCreateCellDelegate: AnyObject {
    func nextButtonCreate(cell: TriggerSMSCreateTableViewCell, index: IndexPath, triggerNetworkType: String)
}

class TriggerSMSCreateTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var taskBtn: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var networkViewSMS: UIView!
    @IBOutlet weak var networkViewSMSTarget: UIView!
    @IBOutlet weak var networkViewSMSNetwork: UIView!
    
    @IBOutlet weak var selectSMSTagetEmptyTextLabel: UILabel!
    @IBOutlet weak var selectSMSNetworkEmptyTextLabel: UILabel!
    @IBOutlet weak var networkSMSTagetSelectonButton: UIButton!
    @IBOutlet weak var networkSMSNetworkSelectonButton: UIButton!
    @IBOutlet weak var selectSMSTargetTextLabel: UILabel!
    @IBOutlet weak var selectSMSNetworkTextLabel: UILabel!
    
    @IBOutlet weak var networkViewEmail: UIView!
    @IBOutlet weak var networkViewEmailTarget: UIView!
    @IBOutlet weak var networkViewEmailNetwork: UIView!
    
    @IBOutlet weak var selectEmailTagetEmptyTextLabel: UILabel!
    @IBOutlet weak var selectEmailNetworkEmptyTextLabel: UILabel!
    @IBOutlet weak var networkEmailTagetSelectonButton: UIButton!
    @IBOutlet weak var networkEmailNetworkSelectonButton: UIButton!
    @IBOutlet weak var selectEmailTargetTextLabel: UILabel!
    @IBOutlet weak var selectEmailNetworkTextLabel: UILabel!
    
    @IBOutlet weak var networkViewTask: UIView!
    @IBOutlet weak var networkViewTaskNetwork: UIView!
    @IBOutlet weak var taskNameTextField: CustomTextField!
    @IBOutlet weak var assignTaskEmptyTextLabel: UILabel!
    @IBOutlet weak var assignTaskNetworkSelectonButton: UIButton!
    @IBOutlet weak var assignTaskNetworkTextLabel: UILabel!
    @IBOutlet weak var createNextButton: UIButton!
    
    var selectedemailTemplateId: String = String.blank
    var selectedSmsTemplateId: String = String.blank
    var selectedTriggerTarget: String = String.blank
    weak var delegate: TriggerCreateCellDelegate?
    var networkTypeSelected: String = "SMS"
    var indexPath = IndexPath()
    
    let radioController: RadioButtonController = RadioButtonController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.setupUI()
        radioController.buttonsArray = [smsBtn, emailBtn, taskBtn]
        radioController.defaultButton = smsBtn
    }
    
    func setupUI() {
        networkViewEmailTarget.layer.cornerRadius = 4.5
        networkViewEmailTarget.layer.borderWidth = 1
        networkViewEmailTarget.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        networkViewEmailNetwork.layer.cornerRadius = 4.5
        networkViewEmailNetwork.layer.borderWidth = 1
        networkViewEmailNetwork.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        networkViewSMSTarget.layer.cornerRadius = 4.5
        networkViewSMSTarget.layer.borderWidth = 1
        networkViewSMSTarget.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        networkViewSMSNetwork.layer.cornerRadius = 4.5
        networkViewSMSNetwork.layer.borderWidth = 1
        networkViewSMSNetwork.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        networkViewTaskNetwork.layer.cornerRadius = 4.5
        networkViewTaskNetwork.layer.borderWidth = 1
        networkViewTaskNetwork.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    }
    
    func configureCell(index: IndexPath) {
        indexPath = index
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonCreate(cell: self, index: indexPath, triggerNetworkType: networkTypeSelected)
    }
    
    @IBAction func smsButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        networkViewSMS.isHidden = false
        networkViewEmail.isHidden = true
        networkViewTask.isHidden = true
        networkTypeSelected = "SMS"
    }
    
    @IBAction func emailButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        networkViewSMS.isHidden = true
        networkViewEmail.isHidden = false
        networkViewTask.isHidden = true
        networkTypeSelected = "EMAIL"
    }
    
    @IBAction func taskButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        networkViewSMS.isHidden = true
        networkViewEmail.isHidden = true
        networkViewTask.isHidden = false
        networkTypeSelected = "task"
    }
}
