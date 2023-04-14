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
    func taskUserCreatedSuccessfully(responseMessage: String)
    func errorReceived(error: String)
}

class CreateTasksViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var usersTextField: CustomTextField!
    @IBOutlet weak var statusTextField: CustomTextField!
    @IBOutlet weak var DeadlineTextField: CustomTextField!
    @IBOutlet weak var leadTextField: CustomTextField!
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
    var dateFormater: DateFormaterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateTasksViewModel(delegate: self)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        descriptionTextView.layer.borderWidth = 1.0;
        self.title = "Create Task"
        self.view.ShowSpinner()
        self.viewModel?.getTaskUserList()
        leadTextField.placeholder = "Select Lead"
        setUPUI()
        dateFormater = DateFormater()
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
    
    @objc func buttonAction(_ sender: UIButton!){
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
        self.view.ShowSpinner()
        viewModel?.createTaskUser(name: nameTextField.text ?? String.blank, description: descriptionTextView.text ?? String.blank, workflowTaskStatus: statusTextField.text ?? String.blank, workflowTaskUser: workflowTaskUser, deadline: serverToLocalInputWorking(date: DeadlineTextField.text ?? String.blank), workflowTaskPatient: workflowTaskPatient, questionnaireSubmissionId: questionnaireSubmissionId, leadOrPatient: leadOrPatientSelected)
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

extension CreateTasksViewController: CreateTasksViewControllerProtocol {
    
    func taskUserListRecived(){
        self.viewModel?.getTaskPatientsList()
    }
    
    func taskPatientsListRecived(){
        self.viewModel?.getQuestionnaireSubmissionList()
    }
    
    func taskQuestionnaireSubmissionListRecived(){
        self.view.HideSpinner()
    }
 
    func taskUserCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
}
