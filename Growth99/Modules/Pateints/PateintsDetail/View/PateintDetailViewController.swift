//
//  PateintDetailViewController.swift
//  Growth99
//
//  Created by nitin auti on 04/01/23.
//

import UIKit

protocol PateintDetailViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedPateintDetail()
    func recivedSmsTemplateList()
    func recivedEmailTemplateList()
    func smsSend(responseMessage: String)
    func updatedLeadStatusRecived(responseMessage: String)
    func smsSendSuccessfully(responseMessage: String)
    func emailSendSuccessfully(responseMessage: String)
    func updatedPateintsInfo(responseMessage: String)
}

class PateintDetailViewController: UIViewController, PateintDetailViewControllerProtocol {
    
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var firstName: CustomTextField!
    @IBOutlet private weak var lastName: CustomTextField!
    @IBOutlet private weak var email: CustomTextField!
    @IBOutlet weak var phoneNumber: CustomTextField!
    @IBOutlet private weak var gender: CustomTextField!
    @IBOutlet private weak var dateOfBirth: CustomTextField!
    @IBOutlet private weak var notes: CustomTextField!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var pateintDetailTableView: UITableView!
    @IBOutlet private weak var newButton: UIButton!
    @IBOutlet private weak var existingButton: UIButton!
    @IBOutlet private weak var scrollViewHight: NSLayoutConstraint!
    @IBOutlet private weak var firstNameButton: UIButton!
    @IBOutlet private weak var lastNameButton: UIButton!
    @IBOutlet private weak var phoneNumberButton: UIButton!
    @IBOutlet private weak var dateOfBirthButton: UIButton!
    @IBOutlet private weak var genderButton: UIButton!
    @IBOutlet private weak var notesButton: UIButton!
    @IBOutlet weak var subView: UIView!
    
    var dateFormater : DateFormaterProtocol?
    var viewModel: PateintDetailViewModelProtocol?
    var pateintData: PateintsDetailListModel?
    var selctedSmsTemplateId = Int()
    var workflowTaskPatientId = Int()
    var selctedTemplate = String()
    var smsBody: String = ""
    var emailBody: String = ""
    var emailSubject: String = ""
    var buttons: [UIButton] = []
    
    var tableViewHeight: CGFloat {
        pateintDetailTableView.layoutIfNeeded()
        return pateintDetailTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.ShowSpinner()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.viewModel = PateintDetailViewModel(delegate: self)
        dateFormater = DateFormater()
        viewModel?.getpateintsList(pateintId: self.workflowTaskPatientId)
        buttons = [newButton, existingButton]
        self.phoneNumber.addTarget(self, action:
                                                #selector(PateintDetailViewController.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
    }
    
    @objc func dateFromButtonPressed() {
        self.dateOfBirth.text = dateFormater?.dateFormatterString(textField: dateOfBirth)
    }
    
    @IBAction func openQuestionarieList (sender: UIButton) {
        let QuestionarieVC = UIStoryboard(name: "QuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "QuestionarieViewController") as! QuestionarieViewController
        QuestionarieVC.pateintId = workflowTaskPatientId
        self.navigationController?.pushViewController(QuestionarieVC, animated: true)
    }
    
    @IBAction func openTaskList(sender: UIButton) {
        let TasksListVC = UIStoryboard(name: "TasksListViewController", bundle: nil).instantiateViewController(withIdentifier: "TasksListViewController") as! TasksListViewController
        TasksListVC.workflowTaskPatientId = workflowTaskPatientId
        TasksListVC.screenTitile = "Patient Task"
        self.navigationController?.pushViewController(TasksListVC, animated: true)
    }
    
    func setUpClearColor() {
        self.firstName.borderColor = .clear
        self.firstNameButton.isSelected = false
        self.firstName.isUserInteractionEnabled = false
        
        self.lastName.borderColor = .clear
        self.lastNameButton.isSelected = false
        self.lastName.isUserInteractionEnabled = false
        
        self.email.borderColor = .clear
        
        self.phoneNumber.borderColor = .clear
        self.phoneNumberButton.isSelected = false
        self.phoneNumber.isUserInteractionEnabled = false
       
        self.gender.borderColor = .clear
        self.genderButton.isSelected = false
        self.gender.isEnabled = false

        self.dateOfBirth.borderColor = .clear
        self.dateOfBirthButton.isSelected = false
        self.dateOfBirth.isUserInteractionEnabled = false
        
        self.notes.borderColor = .clear
        self.notesButton.isSelected = false
        self.notes.isUserInteractionEnabled = false
    }
    
    func registerCell() {
        pateintDetailTableView.register(UINib(nibName: "questionAnswersTableViewCell", bundle: nil), forCellReuseIdentifier: "questionAnswersTableViewCell")
        pateintDetailTableView.register(UINib(nibName: "PateintSMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintSMSTemplateTableViewCell")
        pateintDetailTableView.register(UINib(nibName: "PateintCustomSMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintCustomSMSTemplateTableViewCell")
        pateintDetailTableView.register(UINib(nibName: "PateintEmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintEmailTemplateTableViewCell")
        pateintDetailTableView.register(UINib(nibName: "PateintCustomEmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintCustomEmailTemplateTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerCell()
        setUpClearColor()
        dateOfBirth.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        
        newButton.addTarget(self, action: #selector(self.pateintStatusTemplate(_:)), for:.touchUpInside)
        existingButton.addTarget(self, action: #selector(self.pateintStatusTemplate(_:)), for:.touchUpInside)
        scrollViewHight.constant = tableViewHeight + 1000
    }
    
    @objc func pateintStatusTemplate(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        print(sender.titleLabel?.text ?? String.blank)
        let str = sender.titleLabel?.text ?? String.blank
        self.view.ShowSpinner()
        viewModel?.updatePateintStatus(template: "\(pateintData?.id ?? 0)/status/\(str.uppercased())")
    }
    
    func updatedLeadStatusRecived(responseMessage: String) {
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        viewModel?.getpateintsList(pateintId: pateintData?.id ?? 0)
    }
    
    func setLeadStatus(status: String) {
        if status == "NEW" {
            newButton.isSelected = true
        }else if (status == "EXISTING" ) {
            existingButton.isSelected = true
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func recivedPateintDetail() {
        self.setUpUI()
        pateintDetailTableView.reloadData()
        scrollViewHight.constant = tableViewHeight + 1000
        view.setNeedsLayout()
        self.setLeadStatus(status: viewModel?.pateintsDetailListData?.patientStatus ?? String.blank)
        viewModel?.getSMSDefaultList()
    }
    
    func setUpUI() {
        pateintData = viewModel?.pateintsDetailListData
        firstName.text = pateintData?.firstName ?? "-"
        lastName.text = pateintData?.lastName ?? "-"
        email.text = pateintData?.email ?? "-"
        phoneNumber.text = pateintData?.phone ?? "-"
        gender.text = pateintData?.gender ?? "-"
        notes.text = pateintData?.notes ?? "-"
        self.dateOfBirth.text = pateintData?.dateOfBirth ?? "-"
        let dateOfBirth = dateFormater?.serverToLocalDateFormate(date: pateintData?.dateOfBirth ?? "")
        self.dateOfBirth.text = dateOfBirth ?? "-"
        self.fullName.text = (pateintData?.firstName ?? String.blank) + " " + (pateintData?.lastName ?? String.blank)
    }
    
    @IBAction func openGenderSelction(sender: UIButton) {
        let list =  ["Male","Female"]
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.gender.text  = text
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(list.count * 44))), arrowDirection: .up), from: self)
    }
   
    func recivedSmsTemplateList(){
        viewModel?.getEmailDefaultList()
    }
    
    func recivedEmailTemplateList(){
        self.view.HideSpinner()
    }
    
    func smsSend(responseMessage: String) {
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        self.pateintDetailTableView.reloadData()
        self.viewModel?.getpateintsList(pateintId: self.workflowTaskPatientId)
    }
    
    func updatedPateintsInfo(responseMessage: String) {
        DispatchQueue.main.async {
            self.view.HideSpinner()
            self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
            self.setUpClearColor()
        }
    }
    
    func smsSendSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
    }
    
    func emailSendSuccessfully(responseMessage: String)  {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
    }
    
}

extension PateintDetailViewController: PateintSMSTemplateTableViewCellDelegate,
                                       PateintCustomSMSTemplateTableViewCellDelegate{
   
    func selectSMSTemplate(cell: PateintSMSTemplateTableViewCell) {
        let list = viewModel?.smsTemplateListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            cell.smsTextFiled.text = selectedItem?.name
            self?.selctedSmsTemplateId = selectedItem?.id ?? 0
            cell.smsSendButton.isUserInteractionEnabled = true
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: cell.smsTextFiledButton, size: CGSize(width: cell.smsTextFiledButton.frame.width, height: (Double(list.count * 44) + 10)), arrowDirection: .up), from: self)
    }
    
    func sendSMSTemplateList(cell: PateintSMSTemplateTableViewCell) {
        self.selctedTemplate =  "\(pateintData?.id ?? 0)/sms-template/\(self.selctedSmsTemplateId)"
       
        if cell.smsTextFiled.text == "" {
            return
        }
        self.view.ShowSpinner()
        viewModel?.sendSMSTemplate(template: selctedTemplate)
    }
    
    func sendCustomSMSTemplateList(cell: PateintCustomSMSTemplateTableViewCell, index: IndexPath) {
        if let txtField = cell.smsTextView.text, txtField == "" {
            cell.errorLbi.isHidden = false
            return
        }
        self.view.ShowSpinner()
        viewModel?.sendCustomSMS(leadId: pateintData?.id ?? 0, phoneNumber: "", body: cell.smsTextView.text)
    }
    
}

extension PateintDetailViewController: PateintEmailTemplateTableViewCellDelegate,
                                       PateintCustomEmailTemplateTableViewCellDelegate {
    
    func selectEmailTemplate(cell: PateintEmailTemplateTableViewCell) {
        let list = viewModel?.emailTemplateListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            cell.emailTextFiled.text = selectedItem?.name
            self?.selctedSmsTemplateId = selectedItem?.id ?? 0
            cell.emailSendButton.isUserInteractionEnabled = true
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: cell.emailTextFiledButton, size: CGSize(width: cell.emailTextFiledButton.frame.width, height: (Double(list.count * 44) + 10)), arrowDirection: .up), from: self)
    }
    
    func sendEmailTemplateList() {
        self.selctedTemplate = "\(pateintData?.id ?? 0)/email-template/\(self.selctedSmsTemplateId)"
       
        self.view.ShowSpinner()
        viewModel?.sendEmailTemplate(template: selctedTemplate)
    }
    
    func sendCustomEmailTemplateList(cell: PateintCustomEmailTemplateTableViewCell) {
            if let txtField = cell.emailTextFiled.text, txtField == ""  {
                cell.emailTextFiled.showError(message: "Email Subject is required.")
                return
            }
            if let txtField = cell.emailTextView.text, txtField == ""  {
                cell.errorLbi.isHidden = false
                return
            }
            self.view.ShowSpinner()
            viewModel?.sendCustomEmail(leadId: pateintData?.id ?? 0, email: pateintData?.email ?? String.blank, subject: cell.emailTextFiled.text ?? String.blank, body: cell.emailTextView.text)
    }
}

extension PateintDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 1000
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 1000
    }
}

extension PateintDetailViewController {
    
    @IBAction func editFirstName(sender: UIButton) {
        firstName.borderColor = .gray
        firstName.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.workflowTaskPatientId,  inputString: "firstName", ansString: firstName.text ?? String.blank)
            sender.isSelected = false
            sender.setImage(UIImage(named: "edit"), for: .normal)
        }
        sender.isSelected = true
    }
    
    
    @IBAction func editLastName(sender: UIButton) {
        lastName.borderColor = .gray
        lastName.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.workflowTaskPatientId,  inputString: "lastName", ansString: lastName.text ?? String.blank)
            sender.isSelected = false
            sender.setImage(UIImage(named: "edit"), for: .normal)
        }
        sender.isSelected = true
    }
    
    @IBAction func editPhoneNumber(sender: UIButton) {
        phoneNumber.borderColor = .gray
        phoneNumber.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.workflowTaskPatientId,  inputString: "phone", ansString: phoneNumber.text ?? String.blank)
            sender.isSelected = false
            sender.setImage(UIImage(named: "edit"), for: .normal)
        }
        sender.isSelected = true
    }
    
    @IBAction func editGender(sender: UIButton) {
        gender.borderColor = .gray
        gender.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.workflowTaskPatientId,  inputString: "gender", ansString: (gender.text ?? String.blank))
            sender.isSelected = false
            sender.setImage(UIImage(named: "edit"), for: .normal)
            
        }
        sender.isSelected = true
    }
    
    @IBAction func editDateOfBirth(sender: UIButton) {
        dateOfBirth.borderColor = .gray
        dateOfBirth.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.workflowTaskPatientId,  inputString: "dateOfBirth", ansString: dateOfBirth.text ?? String.blank)
        }
        sender.isSelected = true
    }
    
    
    @IBAction func editNotes(sender: UIButton) {
        notes.borderColor = .gray
        notes.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.workflowTaskPatientId,  inputString: "notes", ansString: notes.text ?? String.blank)
            sender.isSelected = false
            sender.setImage(UIImage(named: "edit"), for: .normal)
        }
        sender.isSelected = true
    }
    
}
