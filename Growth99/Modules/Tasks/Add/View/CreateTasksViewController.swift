//
//  CreateTasksViewController.swift
//  Growth99
//
//  Created by nitin auti on 12/01/23.
//

import UIKit

protocol CreateTasksViewControllerProtocol: AnyObject {
    func taskUserListRecived()
    func taskPatientsListRecived()
    func taskQuestionnaireSubmissionListRecived()
    func errorReceived(error: String)
    func taskUserCreatedSuccessfully(responseMessage: String)
}

class CreateTasksViewController: UIViewController , CreateTasksViewControllerProtocol{
    
    @IBOutlet private weak var nameTextField: CustomTextField!
    @IBOutlet private weak var usersTextField: CustomTextField!
    @IBOutlet private weak var statusTextField: CustomTextField!
    @IBOutlet private weak var DeadlineTextField: CustomTextField!
    @IBOutlet private weak var leadTextField: CustomTextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var leadButton: UIButton!
    @IBOutlet private weak var patientButton: UIButton!
    @IBOutlet private weak var leadOrPatientLabel: UILabel!


    var viewModel: CreateTasksViewModelProtocol?
    var buttons = [UIButton]()
    var workflowTaskUser = Int()
    var workflowTaskPatient: Int = 0
    var questionnaireSubmissionId = Int()
    var leadOrPatientSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateTasksViewModel(delegate: self)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        descriptionTextView.layer.borderWidth = 1.0;
        self.view.ShowSpinner()
        self.viewModel?.getTaskUserList()
        leadTextField.placeholder = "Select Lead"
        setUPUI()
    }
    
    func setUPUI() {
        leadButton.addTarget(self, action: #selector(CreateTasksViewController.buttonAction(_ :)), for:.touchUpInside)
        patientButton.addTarget(self, action: #selector(CreateTasksViewController.buttonAction(_ :)), for:.touchUpInside)
        DeadlineTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        buttons = [leadButton, patientButton]
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
        }else{
            leadOrPatientSelected = "Patient"
            leadTextField.placeholder = "Select patients"
            leadOrPatientLabel.text = "Select patients"
         }
    }
    
    func taskUserListRecived(){
        self.viewModel?.getTaskPatientsList()
    }
    
    func taskPatientsListRecived(){
        self.viewModel?.getQuestionnaireSubmissionList()
    }
    
    func taskQuestionnaireSubmissionListRecived(){
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
        viewModel?.createTaskUser(name: nameTextField.text ?? "", description: descriptionTextView.text ?? "", workflowTaskStatus: statusTextField.text ?? "", workflowTaskUser: workflowTaskUser, deadline: serverToLocalInputWorking(date: DeadlineTextField.text ?? ""), workflowTaskPatient: workflowTaskPatient, questionnaireSubmissionId: questionnaireSubmissionId, leadOrPatient: leadOrPatientSelected)
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
