//
//  CreatePateintsTasksViewController.swift
//  Growth99
//
//  Created by nitin auti on 28/01/23.
//

import UIKit

protocol CreatePateintsTasksViewControllerProtocol: AnyObject {
    func taskUserListRecived()
    func taskUserCreatedSuccessfully(responseMessage: String)
    func errorReceived(error: String)
}

class CreatePateintsTasksViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var usersTextField: CustomTextField!
    @IBOutlet weak var statusTextField: CustomTextField!
    @IBOutlet weak var DeadlineTextField: CustomTextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    var viewModel: CreatePateintsTasksViewModelProtocol?
    var workflowTaskUser = Int()
    var workflowTaskPatient: Int = 0
    var questionnaireSubmissionId = Int()
    var dateFormater: DateFormaterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreatePateintsTasksViewModel(delegate: self)
        self.view.ShowSpinner()
        self.viewModel?.getTaskUserList()
        dateFormater = DateFormater()
        self.title = Constant.Profile.createTasks
        setUPUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let userInfo = [ "selectedIndex" : 2 ]
            NotificationCenter.default.post(name: Notification.Name("changeSegment"), object: nil,userInfo: userInfo)
        }
    }
    
    func setUPUI() {
        self.statusTextField.text = "InComplete"
        DeadlineTextField.tintColor = .clear
        DeadlineTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        self.descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        self.descriptionTextView.layer.borderWidth = 1.0;
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
    
    @IBAction func cancelButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
         
    @IBAction func createTaskUser(sender: UIButton) {
      
        if let textField = nameTextField.text,  textField == "" {
            nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
      
        if let textField = usersTextField.text,  textField == "" {
            usersTextField.showError(message: "Please select user")
            return
        }
        
        if let textField = statusTextField.text,  textField == "" {
            statusTextField.showError(message: "Status is required")
            return
        }
        
        var dedline =  String()
        if DeadlineTextField.text != ""  {
            dedline = serverToLocalInputWorking(date: DeadlineTextField.text ?? "")
        }
        
        var statusText = String()
        if self.statusTextField.text == "In Progress" {
            statusText  = "Inprogress"
        }else{
            statusText  = statusTextField.text ?? String.blank
        }
        
        self.view.ShowSpinner()
        viewModel?.createTaskUser(name: nameTextField.text ?? String.blank, description: descriptionTextView.text ?? String.blank, workflowTaskStatus: statusText, workflowTaskUser: workflowTaskUser, deadline: dedline, workflowTaskPatient: workflowTaskPatient, questionnaireSubmissionId: questionnaireSubmissionId)
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

extension CreatePateintsTasksViewController: CreatePateintsTasksViewControllerProtocol{
    func taskUserListRecived(){
        self.view.HideSpinner()
    }
    
    func taskUserCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
  
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension CreatePateintsTasksViewController {
   
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
}
