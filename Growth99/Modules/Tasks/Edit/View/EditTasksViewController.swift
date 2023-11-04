//
//  EditTasksViewController.swift
//  Growth99
//
//  Created by nitin auti on 15/01/23.
//

import Foundation
import UIKit

protocol EditTasksViewControllerProtocol: AnyObject {
    func taskUserListRecived()
    func taskPatientsListRecived()
    func taskQuestionnaireSubmissionListRecived()
    func taskUserCreatedSuccessfully(responseMessage: String)
    func receivedTaskDetail()
    func errorReceived(error: String)
}

class EditTasksViewController: UIViewController{
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var usersTextField: CustomTextField!
    @IBOutlet weak var statusTextField: CustomTextField!
    @IBOutlet private weak var DeadlineTextField: CustomTextField!
    @IBOutlet private weak var leadTextField: CustomTextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var leadButton: UIButton!
    @IBOutlet private weak var patientButton: UIButton!
    @IBOutlet private weak var leadOrPatientLabel: UILabel!
    
    @IBOutlet private weak var firstNameTextField: CustomTextField!
    @IBOutlet private weak var lastNameTextField: CustomTextField!
    @IBOutlet private weak var phoneNumberTextField: CustomTextField!
    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var leadOrPatientLbi: UILabel!
    @IBOutlet private weak var goToDetailPageButton: UIButton!
    @IBOutlet private weak var LeadOrPatentsHight: NSLayoutConstraint!
    
    var viewModel: EditTasksViewModelProtocol?
    var buttons = [UIButton]()
    var workflowTaskUser = Int()
    var workflowTaskPatient: Int = 0
    var questionnaireSubmissionId = Int()
    var leadOrPatientSelected = ""
    var taskId: Int = 0
    var dateFormater: DateFormaterProtocol?
    
    var screenTitile = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = EditTasksViewModel(delegate: self)
        self.view.ShowSpinner()
        self.viewModel?.getTaskDetail(taskId: taskId)
        self.title = Constant.Profile.tasksDetail
        self.dateFormater = DateFormater()
    }
    
    func setUPUI() {
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        leadButton.addTarget(self, action: #selector(EditTasksViewController.buttonAction(_ :)), for:.touchUpInside)
        patientButton.addTarget(self, action: #selector(EditTasksViewController.buttonAction(_ :)), for:.touchUpInside)
        DeadlineTextField.tintColor = .clear
        DeadlineTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        buttons = [leadButton, patientButton]
        let taskDetail = viewModel?.taskDetailData
        nameTextField.text = taskDetail?.name
        usersTextField.text = taskDetail?.userName
        statusTextField.text = taskDetail?.status
        if taskDetail?.deadLine != nil {
            DeadlineTextField.text = dateFormater?.serverToLocalDateConverterOnlyDate(date: taskDetail?.deadLine ?? "")
        }
        descriptionTextView.text = taskDetail?.description
        workflowTaskUser = taskDetail?.userId ?? 0
    }
    
    func setupLeadOrPatientDetail() {
        let taskDetail = viewModel?.taskDetailData
        self.LeadOrPatentsHight.constant = 500
        if taskDetail?.leadDTO != nil {
            leadButton.isSelected = true
            leadTextField.text = "\(taskDetail?.leadDTO?.firstName ?? String.blank) \(taskDetail?.leadDTO?.lastName ?? String.blank)"
            leadOrPatientLabel.text = "Select Lead"
            firstNameTextField.text = taskDetail?.leadDTO?.firstName
            lastNameTextField.text = taskDetail?.leadDTO?.lastName
            phoneNumberTextField.text = taskDetail?.leadDTO?.phoneNumber
            emailTextField.text = taskDetail?.leadDTO?.email
            leadOrPatientLbi.text = "Lead Information"
            goToDetailPageButton.setTitle("Go To Lead Detail", for: .normal)
            leadOrPatientSelected = "Lead"
            self.questionnaireSubmissionId = taskDetail?.leadId ?? 0
        }else if (taskDetail?.patientDTO != nil) {
            patientButton.isSelected = true
            leadTextField.text = "\(taskDetail?.patientDTO?.firstName ?? String.blank) \(taskDetail?.patientDTO?.lastName ?? String.blank)"
            leadOrPatientLabel.text = "Select patients"
            firstNameTextField.text = taskDetail?.patientDTO?.firstName
            lastNameTextField.text = taskDetail?.patientDTO?.lastName
            phoneNumberTextField.text = taskDetail?.patientDTO?.phoneNumber
            emailTextField.text = taskDetail?.patientDTO?.email
            leadOrPatientLbi.text = "Patient Information"
            goToDetailPageButton.setTitle("Go To Patient Detail", for: .normal)
            leadOrPatientSelected = "Patient"
            self.workflowTaskPatient = taskDetail?.patientId ?? 0
        }else{
            LeadOrPatentsHight.constant = 0
        }
    }
    
    @objc func dateFromButtonPressed() {
        DeadlineTextField.text = dateFormatterString(textField: DeadlineTextField)
    }
    
    func dateFormatterString(textField: CustomTextField) -> String {
        var datePicker = UIDatePicker()
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        leadTextField.text = ""
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 100 {
            leadOrPatientSelected = "Lead"
            leadTextField.placeholder = "Select Lead"
            leadOrPatientLabel.text = "Select Lead"
        } else{
            leadOrPatientSelected = "Patient"
            leadTextField.placeholder = "Select patients"
            leadOrPatientLabel.text = "Select patients"
        }
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToPatientDetail(sender: UIButton) {
      
        if (self.screenTitile == "Lead Task") || (self.screenTitile == "Patient Task") {
            /// check in navaigation PateintDetailViewController
            if (sender.titleLabel?.text == "Go To Lead Detail" ) {
                if let viewControllers = self.navigationController?.viewControllers {
                    for controller in viewControllers {
                        if controller is LeadDetailContainerView {
                            let userInfo = [ "selectedIndex" : 0 ]
                            NotificationCenter.default.post(name: Notification.Name("changeLeadSegment"), object: nil,userInfo: userInfo)
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }
            }else{
                if let viewControllers = self.navigationController?.viewControllers {
                    for controller in viewControllers {
                        if controller is PeteintDetailView {
                            let userInfo = [ "selectedIndex" : 0 ]
                            NotificationCenter.default.post(name: Notification.Name("changeSegment"), object: nil,userInfo: userInfo)
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }
            }
        }else{
            if (sender.titleLabel?.text == "Go To Lead Detail" ) {
                let detailController = UIStoryboard(name: "LeadDetailContainerView", bundle: nil).instantiateViewController(withIdentifier: "LeadDetailContainerView") as! LeadDetailContainerView
                let user = UserRepository.shared
                user.leadId = viewModel?.taskDetailData?.leadId ?? 0
                user.leadFullName = (viewModel?.taskDetailData?.leadDTO?.firstName ?? "") + " " + (viewModel?.taskDetailData?.leadDTO?.lastName ?? "")
                detailController.workflowLeadId = viewModel?.taskDetailData?.leadId ?? 0
                navigationController?.pushViewController(detailController, animated: true)
                
                
            }else if(sender.titleLabel?.text == "Go To Patient Detail" ) {
                let detailController = UIStoryboard(name: "PeteintDetailView", bundle: nil).instantiateViewController(withIdentifier: "PeteintDetailView") as! PeteintDetailView
                detailController.workflowTaskPatientId = viewModel?.taskDetailData?.patientId ?? 0
                navigationController?.pushViewController(detailController, animated: true)
            }
        }
    }
   
    @IBAction func createTaskUser(sender: UIButton) {
        
        if let textField = nameTextField.text,  textField == "" {
            return
        }
        
        if let textField = usersTextField.text,  textField == "" {
            return
        }
        
        if let textField = statusTextField.text,  textField == "" {
            return
        }
        
        var deadLine = String()
        
        if self.DeadlineTextField?.text == "" {
            deadLine = ""
        }else {
            deadLine =  dateFormater?.localToServer(date: DeadlineTextField.text ?? String.blank) ?? ""
        }
        
        var statusText = String()
        if self.statusTextField.text == "In Progress" {
            statusText  = "Inprogress"
        }else{
            statusText  = statusTextField.text ?? String.blank
        }
        
        self.view.ShowSpinner()
        viewModel?.createTaskUser(patientId: taskId, name: nameTextField.text ?? String.blank, description: descriptionTextView.text ?? String.blank, workflowTaskStatus: statusText, workflowTaskUser: workflowTaskUser, deadline: deadLine , workflowTaskPatient: workflowTaskPatient, questionnaireSubmissionId: questionnaireSubmissionId, leadOrPatient: leadOrPatientSelected)
    }
    
    func serverToLocalInputWorking(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
}

extension EditTasksViewController: EditTasksViewControllerProtocol {
   
    func receivedTaskDetail(){
        self.viewModel?.getTaskUserList()
        setUPUI()
    }
    
    func taskUserListRecived(){
        self.viewModel?.getTaskPatientsList()
    }
    
    func taskPatientsListRecived(){
        self.viewModel?.getQuestionnaireSubmissionList()
    }
    
    func taskQuestionnaireSubmissionListRecived(){
        self.setupLeadOrPatientDetail()
        self.view.HideSpinner()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func taskUserCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension EditTasksViewController {
   
    @IBAction func openStatusListDropDwon(sender: UIButton) {
        let rolesArray = ["Completed", "In Progress"]
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.statusTextField.text  = text
        }
        selectionMenu.dismissAutomatically = true
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func openUserListDropDwon(sender: UIButton) {
        let rolesArray = viewModel?.taskUserList ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.firstName
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.usersTextField.text  = text?.firstName
            self?.workflowTaskUser = text?.id ?? 0
        }
        selectionMenu.dismissAutomatically = true
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func openTaskLeadOrPateintsListDropDwon(sender: UIButton) {
        if self.leadOrPatientSelected == "Lead" {
            let finaleListArray = viewModel?.taskQuestionnaireSubmissionList ?? []
            let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: finaleListArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
                cell.textLabel?.text = taskUserList.fullName
            }
            selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
                self?.leadTextField.text  = text?.fullName
                self?.questionnaireSubmissionId = text?.id ?? 0
            }
            selectionMenu.dismissAutomatically = true
            selectionMenu.tableView?.selectionStyle = .single
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(finaleListArray.count * 44))), arrowDirection: .down), from: self)
        } else {
            let finaleListArray = viewModel?.taskPatientsList ?? []
            let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: finaleListArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
                cell.textLabel?.text = taskUserList.name
            }
            selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
                self?.leadTextField.text  = text?.name
                self?.workflowTaskPatient = text?.id ?? 0
            }
            selectionMenu.dismissAutomatically = true
            selectionMenu.tableView?.selectionStyle = .single
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(finaleListArray.count * 44))), arrowDirection: .down), from: self)
        }
    }
    
}
