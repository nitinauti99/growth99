//
//  LeadTaskListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

protocol CreateLeadTasksViewControllerProtocol: AnyObject {
    func taskUserListRecived()
    func taskUserCreatedSuccessfully(responseMessage: String)
    func errorReceived(error: String)
}

class CreateLeadTasksViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var usersTextField: CustomTextField!
    @IBOutlet weak var statusTextField: CustomTextField!
    @IBOutlet weak var DeadlineTextField: CustomTextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    var viewModel: CreateLeadTasksViewModelProtocol?
    var workflowTaskUser = Int()
    var workflowTaskLeadId: Int = 0
    var dateFormater: DateFormaterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadTasksViewModel(delegate: self)
        self.view.ShowSpinner()
        self.viewModel?.getTaskUserList()
        self.dateFormater = DateFormater()
        self.title = Constant.Profile.createTasks
        self.setUPUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let userInfo = [ "selectedIndex" : 2 ]
            NotificationCenter.default.post(name: Notification.Name("changeSegment"), object: nil,userInfo: userInfo)
        }
    }
    
    func setUPUI() {
        DeadlineTextField.tintColor = .clear
        self.DeadlineTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        self.descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        self.descriptionTextView.layer.borderWidth = 1.0;
        self.statusTextField.text = "In Progress"
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
            return
        }
      
        if let textField = usersTextField.text,  textField == "" {
            return
        }
        
        if let textField = statusTextField.text,  textField == "" {
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
        viewModel?.createTaskUser(name: nameTextField.text ?? String.blank, description: descriptionTextView.text ?? String.blank, workflowTaskStatus: statusText, workflowTaskUser: workflowTaskUser, deadline: dedline, questionnaireSubmissionId: workflowTaskLeadId)
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

extension CreateLeadTasksViewController: CreateLeadTasksViewControllerProtocol {
   
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

extension CreateLeadTasksViewController {
    
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
