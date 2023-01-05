//
//  PateintDetailViewController.swift
//  Growth99
//
//  Created by nitin auti on 04/01/23.
//

import UIKit

protocol PateintDetailViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedQuestionnaireList()
    func recivedSmsTemplateList()
    func recivedEmailTemplateList()
    func smsSend(responseMessage: String)
    func updatedLeadStatusRecived(responseMessage: String)
    func smsSendSuccessfully(responseMessage: String)
    func emailSendSuccessfully(responseMessage: String)
}
 
class PateintDetailViewController: UIViewController, PateintDetailViewControllerProtocol {

    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var lastName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var dateOfBirth: UILabel!
    @IBOutlet weak var pateintDetailTableView: UITableView!

    @IBOutlet private weak var newButton: UIButton!
    @IBOutlet private weak var existingButton: UIButton!
    @IBOutlet private weak var scrollViewHight: NSLayoutConstraint!

    var buttons: [UIButton] = []
    var patientQuestionList = [QuestionAnswers]()
    private var viewModel: PateintDetailViewModelProtocol?
    var pateintData: PateintListModel?
    var selctedSmsTemplateId = Int()
    var selctedTemplate = String()
    var smsBody: String = ""
    var emailBody: String = ""
    var emailSubject: String = ""

    var tableViewHeight: CGFloat {
        pateintDetailTableView.layoutIfNeeded()
        return pateintDetailTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.ShowSpinner()
        self.viewModel = PateintDetailViewModel(delegate: self)
      //  viewModel?.getQuestionnaireList(questionnaireId: LeadData?.id ?? 0)
        self.registerCell()
        self.fullName.text = (pateintData?.firstName ?? "") + (pateintData?.lastName ?? "")
        buttons = [newButton, existingButton]
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
        newButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        existingButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        scrollViewHight.constant = tableViewHeight + 800
       
    }
    
    @objc func leadStatusTemplate(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        print(sender.titleLabel?.text ?? "")
        let str = sender.titleLabel?.text ?? ""
        self.view.ShowSpinner()
        viewModel?.updateLeadStatus(template: "\(pateintData?.id ?? 0)/status/\(str.uppercased())")
    }
    
    func updatedLeadStatusRecived(responseMessage: String) {
        self.view.showToast(message: responseMessage)
        viewModel?.getQuestionnaireList(questionnaireId: pateintData?.id ?? 0)
    }
    
    func setLeadStatus(status: String) {
        if status == "NEW" {
            newButton.isSelected = true
        }else if (status == "WARM" ) {
            existingButton.isSelected = true
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func recivedQuestionnaireList() {
        patientQuestionList = viewModel?.questionnaireDetailListData ?? []
        pateintDetailTableView.reloadData()
        scrollViewHight.constant = tableViewHeight + 500
        view.setNeedsLayout()
        self.setLeadStatus(status: viewModel?.leadStatus ?? "")
        viewModel?.getSMSDefaultList()
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
        scrollViewHight.constant = tableViewHeight + 800
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 800
    }
}
