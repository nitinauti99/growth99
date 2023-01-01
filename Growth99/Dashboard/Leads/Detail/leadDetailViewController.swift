//
//  leadDetailViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import UIKit

protocol leadDetailViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedQuestionnaireList()
    func recivedSmsTemplateList()
    func recivedEmailTemplateList()
    func smsSend(responseMessage: String)
    func updatedLeadStatusRecived(responseMessage: String)
    func smsSendSuccessfully(responseMessage: String)
    func emailSendSuccessfully(responseMessage: String)
}

class leadDetailViewController: UIViewController,leadDetailViewControllerProtocol {
   
    @IBOutlet private weak var symptoms: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var lastName: UILabel!
    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var sourceURL: UILabel!
    @IBOutlet private weak var landingPage: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var scrollViewHight: NSLayoutConstraint!
    @IBOutlet private weak var anslistTableView: UITableView!
    @IBOutlet private weak var newButton: UIButton!
    @IBOutlet private weak var coldButton: UIButton!
    @IBOutlet private weak var warmButton: UIButton!
    @IBOutlet private weak var hotButton: UIButton!
    @IBOutlet private weak var wonButton: UIButton!
    @IBOutlet private weak var deadButton: UIButton!
    @IBOutlet private weak var fullName: UILabel!

    var buttons: [UIButton] = []
    var patientQuestionList = [QuestionAnswers]()
    private var viewModel: leadDetailViewProtocol?
    var LeadData: leadModel?
    var selctedSmsTemplateId = Int()
    var selctedTemplate = String()
    var smsBody: String = ""
    var emailBody: String = ""
    var emailSubject: String = ""

    var tableViewHeight: CGFloat {
        anslistTableView.layoutIfNeeded()
        return anslistTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(updateLeadInfo))
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        self.view.ShowSpinner()
        self.viewModel = leadDetailViewModel(delegate: self)
        viewModel?.getQuestionnaireList(questionnaireId: LeadData?.id ?? 0)
        self.registerCell()
        self.fullName.text = LeadData?.fullName
        buttons = [newButton, coldButton, warmButton, hotButton, wonButton, deadButton]
    }
   
    func registerCell() {
        anslistTableView.register(UINib(nibName: "questionAnswersTableViewCell", bundle: nil), forCellReuseIdentifier: "questionAnswersTableViewCell")
        anslistTableView.register(UINib(nibName: "SMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "SMSTemplateTableViewCell")
        anslistTableView.register(UINib(nibName: "CustomSMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSMSTemplateTableViewCell")
        anslistTableView.register(UINib(nibName: "EmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "EmailTemplateTableViewCell")
        anslistTableView.register(UINib(nibName: "CustomEmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomEmailTemplateTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        coldButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        warmButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        hotButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        wonButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        deadButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
    }
    
    @objc func leadStatusTemplate(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        print(sender.titleLabel?.text ?? "")
        let str = sender.titleLabel?.text ?? ""
        self.view.ShowSpinner()
        viewModel?.updateLeadStatus(template: "\(LeadData?.id ?? 0)/status/\(str.uppercased())")
    }
    
    func updatedLeadStatusRecived(responseMessage: String) {
        self.view.showToast(message: responseMessage)
        viewModel?.getQuestionnaireList(questionnaireId: LeadData?.id ?? 0)
    }
    
    func setLeadStatus(status: String) {
        if status == "NEW" {
            newButton.isSelected = true
        }else if (status == "WARM" ) {
            warmButton.isSelected = true
        }else if (status == "COLD" ) {
            coldButton.isSelected = true
        }else if (status == "HOT" ) {
            hotButton.isSelected = true
        }else if (status == "WON" ) {
            wonButton.isSelected = true
        }else if (status == "DEAD" ) {
            deadButton.isSelected = true
        }
    }
    
    @objc func updateLeadInfo() {
        let editLeadVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        editLeadVC.LeadData = LeadData
        self.present(editLeadVC, animated: true)
    }
    
    @objc func updateUI(){
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.title = "Lead Detail"
    }

    @objc private func editButtonPressed(_ sender: UIButton) {
        let editLeadVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        editLeadVC.LeadData = LeadData
        self.present(editLeadVC, animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func recivedQuestionnaireList() {
        patientQuestionList = viewModel?.questionnaireDetailListData ?? []
        anslistTableView.reloadData()
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
        anslistTableView.reloadData()
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
         selctedTemplate =  "\(LeadData?.id ?? 0)/sms-template/\(self.selctedSmsTemplateId)"
         self.sendTemplate()
    }
    
    @objc func sendEmailTemplateList(_ sender: UIButton) {
        selctedTemplate = "\(LeadData?.id ?? 0)/email-template/\(self.selctedSmsTemplateId)"
        self.sendTemplate()
    }
    
    @objc func sendCustomSMSTemplateList(_ sender: UIButton) {
        let cellIndexPath = IndexPath(item: sender.tag, section: 4)
        if let cell = anslistTableView.cellForRow(at: cellIndexPath) as? CustomSMSTemplateTableViewCell {
            if let txtField = cell.smsTextView.text, txtField == "" {
                cell.errorLbi.isHidden = false
                return
            }
            self.view.ShowSpinner()
            viewModel?.sendCustomSMS(leadId: LeadData?.id ?? 0, phoneNumber: LeadData?.PhoneNumber ?? "", body: cell.smsTextView.text)
        }
    }
    
    func smsSendSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
    }
   

    @objc func sendCustomEmailTemplateList(_ sender: UIButton) {
        let cellIndexPath = IndexPath(item: sender.tag, section: 3)
        if let cell = anslistTableView.cellForRow(at: cellIndexPath) as? CustomEmailTemplateTableViewCell {
            if let txtField = cell.emailTextFiled.text, txtField == ""  {
                cell.emailTextFiled.showError(message: "Email Subject is required.")
                return
            }
            if let txtField = cell.emailTextView.text, txtField == ""  {
                cell.errorLbi.isHidden = false
                return
            }
            self.view.ShowSpinner()
            viewModel?.sendCustomEmail(leadId: LeadData?.id ?? 0, email: LeadData?.Email ?? "", subject: cell.emailTextFiled.text ?? "", body: cell.emailTextView.text)
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

extension leadDetailViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return patientQuestionList.count
        }else  {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let item = patientQuestionList[indexPath.row]
            guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "questionAnswersTableViewCell") as? questionAnswersTableViewCell else { return UITableViewCell() }
            
            cell.qutionNameLbi.text = item.questionName
            cell.ansLbi.text = item.answerText
            cell.editButton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
            cell.editButton.isHidden = true
            if item.questionName == "First Name" || item.questionName == "Last Name" || item.questionName == "Email" || item.questionName == "Phone Number" {
                cell.editButton.isHidden = false
                let image = UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate)
                cell.editButton.setImage(image, for: .normal)
                cell.editButton.tintColor = UIColor.init(hexString: "009EDE")
            }
            return cell
       
        } else if indexPath.section == 1 {
            guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "SMSTemplateTableViewCell") as? SMSTemplateTableViewCell else { return UITableViewCell() }
            cell.smsSendButton.layer.cornerRadius = 5
            cell.smsSendButton.layer.borderWidth = 1
            cell.smsSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
            cell.smsSendButton.addTarget(self, action: #selector(self.sendSmsTemplateList(_:)), for:.touchUpInside)
         
            cell.smsTextFiled.addTarget(self, action: #selector(leadDetailViewController.smsTemplateList(_:)), for:.touchDown)
            cell.smsTextFiled.text = "Selecte SMS template"
            
            return cell
      
        } else if indexPath.section == 2 {
            
           guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "EmailTemplateTableViewCell") as? EmailTemplateTableViewCell else { return UITableViewCell() }
           cell.emailSendButton.layer.cornerRadius = 5
           cell.emailSendButton.layer.borderWidth = 1
           cell.emailSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
           cell.emailSendButton.addTarget(self, action: #selector(self.sendEmailTemplateList(_:)), for:.touchUpInside)

           cell.emailTextFiled.addTarget(self, action: #selector(leadDetailViewController.emailTemplateList(_:)), for:.touchDown)
            cell.emailTextFiled.text = "Select Email template"

           return cell
    
       } else if indexPath.section == 3 {
          guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "CustomEmailTemplateTableViewCell") as? CustomEmailTemplateTableViewCell else { return UITableViewCell() }
          cell.emailSendButton.layer.cornerRadius = 5
          cell.emailSendButton.layer.borderWidth = 1
          cell.emailSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
          cell.emailSendButton.addTarget(self, action: #selector(self.sendCustomEmailTemplateList(_:)), for:.touchUpInside)
           emailBody = cell.emailTextView.text
           emailSubject = cell.emailTextFiled.text ?? ""
           cell.emailSendButton.tag = indexPath.row
           cell.errorLbi.isHidden = true

        return cell
    
       } else if indexPath.section == 4 {
         guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "CustomSMSTemplateTableViewCell") as? CustomSMSTemplateTableViewCell else { return UITableViewCell() }
         cell.smsSendButton.layer.cornerRadius = 5
         cell.smsSendButton.layer.borderWidth = 1
         cell.smsSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
         smsBody = cell.smsTextView.text
         cell.smsSendButton.addTarget(self, action: #selector(self.sendCustomSMSTemplateList(_:)), for:.touchUpInside)
           cell.smsSendButton.tag = indexPath.row
           cell.errorLbi.isHidden = true

         return cell
      }
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 220
        }else if indexPath.section == 2 {
            return 220
        }else if indexPath.section == 3 {
            return 320
        }else if indexPath.section == 4 {
            return 240
        } else {
            return 80
        }
    }
    
}

extension leadDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 500
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 500
    }
}
