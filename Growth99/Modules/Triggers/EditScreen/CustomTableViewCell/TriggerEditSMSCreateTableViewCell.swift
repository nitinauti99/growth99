//
//  TriggerEditSMSCreateTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerEditCreateCellDelegate: AnyObject {
    func nextButtonCreate(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, triggerNetworkType: String)
   
    // sms selection
    func smsTargetButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, sender: UIButton)
    func smsNetworkButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, smsTargetType: String)
   
    // email selection
    func emailTargetButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath)
    func emailNetworkButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, emailTargetType: String)
    
    // task selction
    func taskNetworkNetworkButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath)
}

class TriggerEditSMSCreateTableViewCell: UITableViewCell {

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

    weak var delegate: TriggerEditCreateCellDelegate?
    var networkTypeSelected: String = "sms"
    var indexPath = IndexPath()
    var trigerCreateData: [TriggerEditData] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.setupUI()
    }
    
    func configureCell(triggerEditData: [TriggerEditData]?, index: IndexPath, moduleSelectionTypeTrigger: String, selectedNetworkType: String, parentViewModel: TriggerEditDetailViewModelProtocol?){
      
        self.indexPath = index
        self.trigerCreateData = triggerEditData ?? []
        self.networkSMSTagetSelectonButton.addTarget(self, action: #selector(smsTargetSelectionMethod), for: .touchDown)
        
        self.networkSMSNetworkSelectonButton.addTarget(self, action: #selector(smsNetworkSelectionMethod), for: .touchDown)
        
        self.networkEmailTagetSelectonButton.addTarget(self, action: #selector(emailTargetSelectionMethod), for: .touchDown)
        
        self.networkEmailNetworkSelectonButton.addTarget(self, action: #selector(emailNetworkSelectionMethod), for: .touchDown)
        
        if moduleSelectionTypeTrigger == "lead" {
            self.taskBtn.isHidden = false
            self.taskLabel.isHidden = false
            self.assignTaskNetworkSelectonButton.addTarget(self, action: #selector(taskNetworkSelectionMethod), for: .touchDown)
        } else {
            self.taskBtn.isHidden = true
            self.taskLabel.isHidden = true
        }
        
        if triggerEditData?[index.row].triggerType == "SMS" {
            self.smsBtn.isSelected = true
            self.emailBtn.isSelected = false
            self.taskBtn.isSelected = false
            networkViewSMS.isHidden = false
            networkViewEmail.isHidden = true
            networkViewTask.isHidden = true
            
            self.selectSMSTargetTextLabel.text = triggerEditData?[index.row].triggerTarget
            let selectSMSNetworkName = parentViewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.id == triggerEditData?[index.row].triggerTemplate ?? 0} ) ?? []
            if selectSMSNetworkName.count > 0 {
                self.selectSMSNetworkTextLabel.text = selectSMSNetworkName[0].name ?? String.blank
            } else {
                self.selectSMSNetworkTextLabel.text = ""
            }
            
            
        } else if triggerEditData?[index.row].triggerType == "EMAIL" {
            self.smsBtn.isSelected = false
            self.emailBtn.isSelected = true
            self.taskBtn.isSelected = false
            
            self.selectEmailTargetTextLabel.text = triggerEditData?[index.row].triggerTarget
            let selectEmailNetworkName = parentViewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.id == triggerEditData?[index.row].triggerTemplate ?? 0} ) ?? []
            if selectEmailNetworkName.count > 0 {
                self.selectEmailNetworkTextLabel.text = selectEmailNetworkName[0].name ?? String.blank
            } else {
                self.selectEmailNetworkTextLabel.text = ""
            }
            networkViewSMS.isHidden = true
            networkViewEmail.isHidden = false
            networkViewTask.isHidden = true
        } else {
            self.smsBtn.isSelected = false
            self.emailBtn.isSelected = false
            self.taskBtn.isSelected = true
            
            networkViewSMS.isHidden = true
            networkViewEmail.isHidden = true
            networkViewTask.isHidden = false
            
            self.taskNameTextField.text = triggerEditData?[index.row].taskName
            
            let assignTaskName = parentViewModel?.getTriggerDetailDataEdit?.userDTOList?.filter({ $0.id == triggerEditData?[index.row].triggerTemplate ?? 0} ) ?? []
            if assignTaskName.count > 0 {
                self.assignTaskNetworkTextLabel.text = "\(assignTaskName[0].firstName ?? "") \(assignTaskName[0].lastName ?? "")"
            } else {
                self.assignTaskNetworkTextLabel.text = ""
            }
        }
        self.createNextButton.isHidden = true
    }
    
    @objc func smsTargetSelectionMethod(sender: UIButton) {
        self.delegate?.smsTargetButton(cell: self, index: indexPath, sender: sender)
    }
    
    @objc func smsNetworkSelectionMethod(sender: UIButton) {
        self.delegate?.smsNetworkButton(cell: self, index: indexPath, smsTargetType: self.selectSMSTargetTextLabel.text ?? "")
    }
    
    @objc func emailTargetSelectionMethod(sender: UIButton) {
        self.delegate?.emailTargetButton(cell: self, index: indexPath)
    }
    
    @objc func emailNetworkSelectionMethod(sender: UIButton) {
        self.delegate?.emailNetworkButton(cell: self, index: indexPath, emailTargetType: self.selectEmailTargetTextLabel.text ?? "")
    }
    
    @objc func taskNetworkSelectionMethod(sender: UIButton) {
        self.delegate?.taskNetworkNetworkButton(cell: self, index: indexPath)
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
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonCreate(cell: self, index: indexPath, triggerNetworkType: networkTypeSelected)
    }

    @IBAction func smsButtonAction(sender: UIButton) {
        smsBtn.isSelected = !smsBtn.isSelected
        networkViewSMS.isHidden = false
        networkViewEmail.isHidden = true
        networkViewTask.isHidden = true
        networkTypeSelected = "sms"
        emailBtn.isSelected = false
        taskBtn.isSelected = false
    }
    
    @IBAction func emailButtonAction(sender: UIButton) {
        emailBtn.isSelected = !emailBtn.isSelected
        networkViewSMS.isHidden = true
        networkViewEmail.isHidden = false
        networkViewTask.isHidden = true
        networkTypeSelected = "email"
        smsBtn.isSelected = false
        taskBtn.isSelected = false
    }
    
    @IBAction func taskButtonAction(sender: UIButton) {
        taskBtn.isSelected = !taskBtn.isSelected
        networkViewSMS.isHidden = true
        networkViewEmail.isHidden = true
        networkViewTask.isHidden = false
        networkTypeSelected = "task"
        smsBtn.isSelected = false
        emailBtn.isSelected = false
    }
}
