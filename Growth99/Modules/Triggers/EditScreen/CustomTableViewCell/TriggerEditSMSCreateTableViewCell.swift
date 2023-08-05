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
    @IBOutlet weak var networkSMSTagetSelectonButton: UIButton!
    @IBOutlet weak var networkSMSNetworkSelectonButton: UIButton!
    @IBOutlet weak var smsTargetTF: CustomTextField!
    @IBOutlet weak var smsNetworTF: CustomTextField!
    
    @IBOutlet weak var networkViewEmail: UIView!
    @IBOutlet weak var emailTagetSelectonButton: UIButton!
    @IBOutlet weak var emailNetworkSelectonButton: UIButton!
    @IBOutlet weak var emailTargetTF: CustomTextField!
    @IBOutlet weak var emailNetworTF: CustomTextField!
    
    @IBOutlet weak var networkViewTask: UIView!
    @IBOutlet weak var taskNameTextField: CustomTextField!
    @IBOutlet weak var assignTaskNetworkTF: CustomTextField!
    @IBOutlet weak var assignTaskNetworkSelectonButton: UIButton!
    
    @IBOutlet weak var createNextButton: UIButton!
    @IBOutlet weak var createNextButtonHeight: NSLayoutConstraint!
    
    weak var delegate: TriggerEditCreateCellDelegate?
    var networkTypeSelected: String = "SMS"
    var indexPath = IndexPath()
    var trigerCreateData: [TriggerEditData] = []
    var triggerTargetName: String = ""
    let radioController: RadioButtonController = RadioButtonController()
    var templateId: Int = 0
    var addNewcheck: Bool = false
    var showBordercheck: Bool = false
    var orderOfConditionTriggerCheck: Int = 0
    var isNewCellCreated: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        radioController.buttonsArray = [smsBtn, emailBtn, taskBtn]
        radioController.defaultButton = smsBtn
    }
    
    func configureCellCreate(index: IndexPath, moduleSelectionTypeTrigger: String) {
        indexPath = index
        self.networkSMSTagetSelectonButton.addTarget(self, action: #selector(smsTargetSelectionMethod), for: .touchDown)
        self.networkSMSNetworkSelectonButton.addTarget(self, action: #selector(smsNetworkSelectionMethod), for: .touchDown)
        self.emailTagetSelectonButton.addTarget(self, action: #selector(emailTargetSelectionMethod), for: .touchDown)
        self.emailNetworkSelectonButton.addTarget(self, action: #selector(emailNetworkSelectionMethod), for: .touchDown)
        self.smsTargetTF.text = ""
        self.smsNetworTF.text = ""
        self.emailTargetTF.text = ""
        self.emailNetworTF.text = ""
        if moduleSelectionTypeTrigger == "leads" {
            self.taskBtn.isHidden = false
            self.taskLabel.isHidden = false
            self.assignTaskNetworkSelectonButton.addTarget(self, action: #selector(taskNetworkSelectionMethod), for: .touchDown)
        } else {
            self.taskBtn.isHidden = true
            self.taskLabel.isHidden = true
        }
        isNewCellCreated = true
        self.createNextButton.isHidden = false
    }
    
    func configureCell(index: IndexPath, triggerEditData: TriggerEditData?, parentViewModel: TriggerEditDetailViewModelProtocol?, viewController: UIViewController, moduleSelectionTypeTrigger: String) {
        self.indexPath = index
        self.networkSMSTagetSelectonButton.addTarget(self, action: #selector(smsTargetSelectionMethod), for: .touchDown)
        self.networkSMSNetworkSelectonButton.addTarget(self, action: #selector(smsNetworkSelectionMethod), for: .touchDown)
        self.emailTagetSelectonButton.addTarget(self, action: #selector(emailTargetSelectionMethod), for: .touchDown)
        self.emailNetworkSelectonButton.addTarget(self, action: #selector(emailNetworkSelectionMethod), for: .touchDown)
        
        //Task will show only on leads
        if moduleSelectionTypeTrigger == "leads" {
            self.taskBtn.isHidden = false
            self.taskLabel.isHidden = false
            self.assignTaskNetworkSelectonButton.addTarget(self, action: #selector(taskNetworkSelectionMethod), for: .touchDown)
        } else {
            self.taskBtn.isHidden = true
            self.taskLabel.isHidden = true
        }
        
        //SMS button click, here hiding email and task view
        if triggerEditData?.triggerType == "SMS" {
            self.smsBtn.isSelected = true
            self.emailBtn.isSelected = false
            self.taskBtn.isSelected = false
            networkViewSMS.isHidden = false
            networkViewEmail.isHidden = true
            networkViewTask.isHidden = true
            
            if triggerEditData?.triggerTarget == "lead" {
                triggerTargetName = "Leads"
            } else {
                let triggerName = triggerEditData?.triggerTarget ?? ""
                triggerTargetName = triggerName.replacingOccurrences(of: "Appointment", with: "")
            }
            self.smsTargetTF.text = triggerTargetName
            templateId = triggerEditData?.triggerTemplate ?? 0
            let selectSMSNetworkName = parentViewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.id == triggerEditData?.triggerTemplate ?? 0} ) ?? []
            if selectSMSNetworkName.count > 0 {
                let smsNetworkNames = selectSMSNetworkName.map { $0.name ?? "" }
                let namesString = smsNetworkNames.joined(separator: ", ")
                self.smsNetworTF.text = namesString
            } else {
                self.smsNetworTF.text = ""
            }
        }
        //EMAIL button click, here hiding sms and task view
        else if triggerEditData?.triggerType == "EMAIL" {
            self.smsBtn.isSelected = false
            self.emailBtn.isSelected = true
            self.taskBtn.isSelected = false
            
            if triggerEditData?.triggerTarget == "lead" {
                triggerTargetName = "Leads"
            } else {
                let triggerName = triggerEditData?.triggerTarget ?? ""
                triggerTargetName = triggerName.replacingOccurrences(of: "Appointment", with: "")
            }
            self.emailTargetTF.text = triggerTargetName
            templateId = triggerEditData?.triggerTemplate ?? 0
            let selectEmailNetworkName = parentViewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.id == triggerEditData?.triggerTemplate ?? 0} ) ?? []
            if selectEmailNetworkName.count > 0 {
                let smsNetworkNames = selectEmailNetworkName.map { $0.name ?? "" }
                let namesString = smsNetworkNames.joined(separator: ", ")
                self.emailNetworTF.text = namesString
            } else {
                self.emailNetworTF.text = ""
            }
            networkViewSMS.isHidden = true
            networkViewEmail.isHidden = false
            networkViewTask.isHidden = true
        }
        //Task button click, here hiding sms and email view
        else {
            self.smsBtn.isSelected = false
            self.emailBtn.isSelected = false
            self.taskBtn.isSelected = true
            
            networkViewSMS.isHidden = true
            networkViewEmail.isHidden = true
            networkViewTask.isHidden = false
            
            self.taskNameTextField.text = triggerEditData?.taskName
            let assignTaskName = parentViewModel?.getTriggerDetailDataEdit?.userDTOList?.filter({ $0.id == triggerEditData?.triggerTemplate ?? 0} ) ?? []
            if assignTaskName.count > 0 {
                let firstName = assignTaskName.map { $0.firstName ?? "" }
                let lastName = assignTaskName.map { $0.lastName ?? "" }
                let fName = firstName.joined(separator: "")
                let lName = lastName.joined(separator: "")
                self.assignTaskNetworkTF.text = "\(fName) \(lName)"
            } else {
                self.assignTaskNetworkTF.text = ""
            }
        }
        isNewCellCreated = false
        addNewcheck = triggerEditData?.addNew ?? false
        showBordercheck = triggerEditData?.showBorder ?? false
        orderOfConditionTriggerCheck = triggerEditData?.orderOfCondition ?? 0
        networkTypeSelected = triggerEditData?.triggerType ?? ""
        self.createNextButton.isHidden = true
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
        networkTypeSelected = "TASK"
    }
    
    @objc func smsTargetSelectionMethod(sender: UIButton) {
        self.delegate?.smsTargetButton(cell: self, index: indexPath, sender: sender)
    }
    
    @objc func smsNetworkSelectionMethod(sender: UIButton) {
        self.delegate?.smsNetworkButton(cell: self, index: indexPath, smsTargetType: self.smsTargetTF.text ?? "")
    }
    
    @objc func emailTargetSelectionMethod(sender: UIButton) {
        self.delegate?.emailTargetButton(cell: self, index: indexPath)
    }
    
    @objc func emailNetworkSelectionMethod(sender: UIButton) {
        self.delegate?.emailNetworkButton(cell: self, index: indexPath, emailTargetType: self.emailTargetTF.text ?? "")
    }
    
    @objc func taskNetworkSelectionMethod(sender: UIButton) {
        self.delegate?.taskNetworkNetworkButton(cell: self, index: indexPath)
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonCreate(cell: self, index: indexPath, triggerNetworkType: networkTypeSelected)
    }
}
