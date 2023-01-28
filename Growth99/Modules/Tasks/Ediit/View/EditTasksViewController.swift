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
    func errorReceived(error: String)
    func taskUserCreatedSuccessfully(responseMessage: String)
    func receivedTaskDetail()
}

class EditTasksViewController: UIViewController , EditTasksViewControllerProtocol{
    
    @IBOutlet private weak var nameTextField: CustomTextField!
    @IBOutlet private weak var usersTextField: CustomTextField!
    @IBOutlet private weak var statusTextField: CustomTextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = EditTasksViewModel(delegate: self)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        descriptionTextView.layer.borderWidth = 1.0;
        self.view.ShowSpinner()
        self.viewModel?.getTaskDetail(taskId: taskId)
    }
    
    func setUPUI() {
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        leadButton.addTarget(self, action: #selector(EditTasksViewController.buttonAction(_ :)), for:.touchUpInside)
        patientButton.addTarget(self, action: #selector(EditTasksViewController.buttonAction(_ :)), for:.touchUpInside)
        DeadlineTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        buttons = [leadButton, patientButton]
        let taskDetail = viewModel?.taskDetailData
        
        nameTextField.text = taskDetail?.name
        usersTextField.text = taskDetail?.userName
        statusTextField.text = taskDetail?.status
        DeadlineTextField.text =  taskDetail?.deadLine
        DeadlineTextField.text = dateFormatterString(textField: DeadlineTextField)
        descriptionTextView.text = taskDetail?.description
    }
    
    func setupLeadOrPatientDetail() {
        let taskDetail = viewModel?.taskDetailData
        LeadOrPatentsHight.constant = 500
//        if taskDetail?.leadDTO == nil || taskDetail?.leadDTO == nil{
//            LeadOrPatentsHight.constant = 0
//        }
        if taskDetail?.leadDTO != nil {
            leadButton.isSelected = true
            leadTextField.text = "\(taskDetail?.leadDTO?.firstName ?? "") \(taskDetail?.leadDTO?.lastName ?? "")"
            leadOrPatientLabel.text = "Select Lead"
            firstNameTextField.text = taskDetail?.leadDTO?.firstName
            lastNameTextField.text = taskDetail?.leadDTO?.lastName
            phoneNumberTextField.text = taskDetail?.leadDTO?.phoneNumber
            emailTextField.text = taskDetail?.leadDTO?.email
            leadOrPatientLbi.text = "Lead Information"
            goToDetailPageButton.setTitle("Go To Lead Detail", for: .normal)
           
        }else {
            patientButton.isSelected = true
            leadTextField.text = "\(taskDetail?.patientDTO?.firstName ?? "") \(taskDetail?.patientDTO?.lastName ?? "")"
            leadOrPatientLabel.text = "Select patients"
            firstNameTextField.text = taskDetail?.patientDTO?.firstName
            lastNameTextField.text = taskDetail?.patientDTO?.lastName
            phoneNumberTextField.text = taskDetail?.patientDTO?.phoneNumber
            emailTextField.text = taskDetail?.patientDTO?.email
            leadOrPatientLbi.text = "Patient Information"
            goToDetailPageButton.setTitle("Go To Patient Detail", for: .normal)
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
        let todaysDate = Date()
        datePicker.minimumDate = todaysDate
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
    
    @objc func buttonAction(_ sender: PassableUIButton!){
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
        self.view.showToast(message: error)
    }
    
    func taskUserCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToPatientDetail(sender: UIButton) {
        let taskDetail = viewModel?.taskDetailData
        if taskDetail?.leadDTO != nil {
            let detailController = UIStoryboard(name: "leadDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "leadDetailViewController") as! leadDetailViewController
            detailController.LeadId = viewModel?.taskDetailData?.leadId ?? 0
            navigationController?.pushViewController(detailController, animated: true)
        }else {
            let detailController = UIStoryboard(name: "PateintDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintDetailViewController") as! PateintDetailViewController
            detailController.workflowTaskPatientId = viewModel?.taskDetailData?.patientId ?? 0
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
    
    @IBAction func openStatusListDropDwon(sender: UIButton) {
       let rolesArray = ["Completed", "Incompleted"]
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.components(separatedBy: " ").first
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
        if leadOrPatientSelected == "Lead" {
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
        self.view.ShowSpinner()
        viewModel?.createTaskUser(name: nameTextField.text ?? "", description: descriptionTextView.text ?? "", workflowTaskStatus: statusTextField.text ?? "", workflowTaskUser: workflowTaskUser, deadline: serverToLocalInputWorking(date: DeadlineTextField.text ?? "") , workflowTaskPatient: workflowTaskPatient, questionnaireSubmissionId: questionnaireSubmissionId, leadOrPatient: leadOrPatientSelected)
       }
    
    func serverToLocalInputWorking(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
}
