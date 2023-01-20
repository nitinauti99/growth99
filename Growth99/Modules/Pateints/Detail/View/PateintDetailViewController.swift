//
//  PateintDetailViewController.swift
//  Growth99
//
//  Created by nitin auti on 04/01/23.
//

import UIKit
import ScrollableSegmentedControl

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
    @IBOutlet private weak var phoneNumber: CustomTextField!
    @IBOutlet private weak var gender: CustomTextField!
    @IBOutlet private weak var dateOfBirth: CustomTextField!
    @IBOutlet private weak var notes: CustomTextField!

    @IBOutlet weak var pateintDetailTableView: UITableView!
    @IBOutlet private weak var newButton: UIButton!
    @IBOutlet private weak var existingButton: UIButton!
    @IBOutlet private weak var scrollViewHight: NSLayoutConstraint!
    @IBOutlet private weak var FirstNameButton: UIButton!
    @IBOutlet private weak var notesButton: UIButton!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!

    var dateFormater : DateFormaterProtocol?
    private var viewModel: PateintDetailViewModelProtocol?
    var pateintData: PateintsDetailListModel?
    var selctedSmsTemplateId = Int()
    var pateintId = Int()
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
        self.viewModel = PateintDetailViewModel(delegate: self)
        dateFormater = DateFormater()
        viewModel?.getpateintsList(pateintId: self.pateintId)
        self.registerCell()
        buttons = [newButton, existingButton]
        setUpClearColor()
        gender.addTarget(self, action: #selector(openGenderSelction(_ : )), for: .touchDown)
        dateOfBirth.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
       
           segmentedControl.segmentStyle = .textOnly
           segmentedControl.insertSegment(withTitle: "Segment 1", at: 0)
           segmentedControl.insertSegment(withTitle: "Segment 2", at: 1)
           segmentedControl.insertSegment(withTitle: "Segment 3", at: 2)
           segmentedControl.insertSegment(withTitle: "Segment 4", at: 3)
           segmentedControl.insertSegment(withTitle: "Segment 5", at: 4)
           segmentedControl.insertSegment(withTitle: "Segment 6", at: 5)
               
           segmentedControl.underlineSelected = true
               
           segmentedControl.addTarget(self, action: #selector(PateintDetailViewController.segmentSelected(sender:)), for: .valueChanged)

           // change some colors
           segmentedControl.segmentContentColor = UIColor.white
           segmentedControl.selectedSegmentContentColor = UIColor.yellow
           segmentedControl.selectedSegmentContentBackroundColor = .red
        // segmentedControl.backgroundColor = UIColor.black
           
           // Turn off all segments been fixed/equal width.
           // The width of each segment would be based on the text length and font size.
           segmentedControl.fixedSegmentWidth = false
    }
    
    @objc func dateFromButtonPressed() {
        dateOfBirth.text = dateFormater?.dateFormatterString(textField: dateOfBirth)
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
    }
    
    func setUpClearColor() {
        firstName.borderColor = .clear
        lastName.borderColor = .clear
        email.borderColor = .clear
        phoneNumber.borderColor = .clear
        gender.borderColor = .clear
        dateOfBirth.borderColor = .clear
        notes.borderColor = .clear
    }
   
    func registerCell() {
        pateintDetailTableView.register(UINib(nibName: "questionAnswersTableViewCell", bundle: nil), forCellReuseIdentifier: "questionAnswersTableViewCell")
        
        pateintDetailTableView.register(UINib(nibName: "SMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "SMSTemplateTableViewCell")
        pateintDetailTableView.register(UINib(nibName: "CustomSMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSMSTemplateTableViewCell")
        pateintDetailTableView.register(UINib(nibName: "EmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "EmailTemplateTableViewCell")
        pateintDetailTableView.register(UINib(nibName: "CustomEmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomEmailTemplateTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newButton.addTarget(self, action: #selector(self.pateintStatusTemplate(_:)), for:.touchUpInside)
        existingButton.addTarget(self, action: #selector(self.pateintStatusTemplate(_:)), for:.touchUpInside)
        scrollViewHight.constant = tableViewHeight + 1000
       
    }
    
    @objc func pateintStatusTemplate(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        print(sender.titleLabel?.text ?? "")
        let str = sender.titleLabel?.text ?? ""
        self.view.ShowSpinner()
        viewModel?.updatePateintStatus(template: "\(pateintData?.id ?? 0)/status/\(str.uppercased())")
    }
    
    func updatedLeadStatusRecived(responseMessage: String) {
        self.view.showToast(message: responseMessage)
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
        self.view.showToast(message: error)
    }
    
    func recivedPateintDetail() {
        self.setUpUI()
        pateintDetailTableView.reloadData()
        scrollViewHight.constant = tableViewHeight + 1000
        view.setNeedsLayout()
        self.setLeadStatus(status: viewModel?.pateintsDetailListData?.patientStatus ?? "")
        viewModel?.getSMSDefaultList()
    }
    
    func setUpUI() {
        pateintData = viewModel?.pateintsDetailListData
        firstName.text = pateintData?.firstName
        lastName.text = pateintData?.lastName
        email.text = pateintData?.email
        phoneNumber.text = pateintData?.phone
        gender.text = pateintData?.gender
        notes.text = pateintData?.notes
        self.dateOfBirth.text = pateintData?.dateOfBirth
        let dateOfBirth = dateFormater?.dateFormatterString(textField: dateOfBirth)
        self.dateOfBirth.text = dateOfBirth
        self.fullName.text = (pateintData?.firstName ?? "") + " " + (pateintData?.lastName ?? "")
    }
    
    @objc func openGenderSelction(_ textfield: UITextField) {
       let list =  ["Male","Female"]
       
       let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.gender.text  = text
            selectionMenu.dismissAutomatically = true
         }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: textfield, size: CGSize(width: textfield.frame.width, height: (Double(list.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func editDateOfBirth(sender: UIButton) {
        dateOfBirth.borderColor = .gray
        dateOfBirth.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.pateintId,  inputString: "dateOfBirth", ansString: dateOfBirth.text ?? "")
        }
        sender.isSelected = true
    }
    
    func recivedSmsTemplateList(){
        viewModel?.getEmailDefaultList()
    }
    
    func recivedEmailTemplateList(){
        self.view.HideSpinner()
    }

    func smsSend(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
        pateintDetailTableView.reloadData()
    }
    
    func updatedPateintsInfo(responseMessage: String) {
        self.view.HideSpinner()
        firstName.isUserInteractionEnabled = true
        self.view.showToast(message: responseMessage)
        setUpClearColor()
    }
    
    ///  multiple selection with selction false
    @objc func smsTemplateList(_ textField: UITextField){
        let list = viewModel?.smsTemplateListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            textField.text = selectedItem?.name
            self?.selctedSmsTemplateId = selectedItem?.id ?? 0
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: textField, size: CGSize(width: textField.frame.width, height: (Double(list.count * 44) + 10)), arrowDirection: .up), from: self)
    }
    
    ///  multiple selection with selction false
    @objc func emailTemplateList(_ textField: UITextField){
        let list = viewModel?.emailTemplateListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            textField.text = selectedItem?.name
            self?.selctedSmsTemplateId = selectedItem?.id ?? 0
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: textField, size: CGSize(width: textField.frame.width, height: (Double(list.count * 44) + 10)), arrowDirection: .up), from: self)
    }
    
     @objc func sendSmsTemplateList(_ sender: UIButton) {
         selctedTemplate =  "\(pateintData?.id ?? 0)/sms-template/\(self.selctedSmsTemplateId)"
         self.sendTemplate()
    }
    
    @objc func sendEmailTemplateList(_ sender: UIButton) {
        selctedTemplate = "\(pateintData?.id ?? 0)/email-template/\(self.selctedSmsTemplateId)"
        self.sendTemplate()
    }
    
    @objc func sendCustomSMSTemplateList(_ sender: UIButton) {
        let cellIndexPath = IndexPath(item: sender.tag, section: 4)
        if let cell = pateintDetailTableView.cellForRow(at: cellIndexPath) as? CustomSMSTemplateTableViewCell {
            if let txtField = cell.smsTextView.text, txtField == "" {
                cell.errorLbi.isHidden = false
                return
            }
            self.view.ShowSpinner()
            viewModel?.sendCustomSMS(leadId: pateintData?.id ?? 0, phoneNumber: "", body: cell.smsTextView.text)
        }
    }
    
    func smsSendSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
    }
   

    @objc func sendCustomEmailTemplateList(_ sender: UIButton) {
        let cellIndexPath = IndexPath(item: sender.tag, section: 3)
        if let cell = pateintDetailTableView.cellForRow(at: cellIndexPath) as? CustomEmailTemplateTableViewCell {
            if let txtField = cell.emailTextFiled.text, txtField == ""  {
                cell.emailTextFiled.showError(message: "Email Subject is required.")
                return
            }
            if let txtField = cell.emailTextView.text, txtField == ""  {
                cell.errorLbi.isHidden = false
                return
            }
            self.view.ShowSpinner()
            viewModel?.sendCustomEmail(leadId: pateintData?.id ?? 0, email: pateintData?.email ?? "", subject: cell.emailTextFiled.text ?? "", body: cell.emailTextView.text)
         }
    }
    
    func emailSendSuccessfully(responseMessage: String)  {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
    }
    
    func sendTemplate() {
        self.view.ShowSpinner()
        viewModel?.sendTemplate(template: selctedTemplate)
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
            viewModel?.updatePateintsInfo(pateintId: self.pateintId,  inputString: "firstName", ansString: firstName.text ?? "")
        }
        sender.isSelected = true
    }
    
    
    @IBAction func editLastName(sender: UIButton) {
        lastName.borderColor = .gray
        lastName.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.pateintId,  inputString: "lastName", ansString: lastName.text ?? "")
        }
        sender.isSelected = true
    }
    
    @IBAction func editPhoneNumber(sender: UIButton) {
        phoneNumber.borderColor = .gray
        phoneNumber.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.pateintId,  inputString: "phone", ansString: phoneNumber.text ?? "")
        }
        sender.isSelected = true
    }
    
    @IBAction func editGender(sender: UIButton) {
        gender.borderColor = .gray
        gender.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.pateintId,  inputString: "gender", ansString: (gender.text ?? "").uppercased())
        }
        sender.isSelected = true
    }
    
    @IBAction func editNotes(sender: UIButton) {
        notes.borderColor = .gray
        notes.isUserInteractionEnabled = true
        if sender.isSelected == true {
            self.view.ShowSpinner()
            viewModel?.updatePateintsInfo(pateintId: self.pateintId,  inputString: "notes", ansString: notes.text ?? "")
        }
        sender.isSelected = true
    }
    
}