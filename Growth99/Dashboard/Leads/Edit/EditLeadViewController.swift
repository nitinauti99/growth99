//
//  EditLeadViewController.swift
//  Growth99
//
//  Created by nitin auti on 05/12/22.
//

import UIKit

protocol EditLeadViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class EditLeadViewController: UIViewController, EditLeadViewControllerProtocol {
    @IBOutlet weak var idTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var ammountTextField: CustomTextField!
    @IBOutlet weak var sourceTextField: CustomTextField!
    @IBOutlet weak var leadStatusTextField: CustomTextField!

    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!

    var patientQuestionAnswers = Array<Any>()
    var viewModel: EditLeadViewModelProtocol?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = EditLeadViewModel(delegate: self)
        setUpUI()
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    func LeadDataRecived() {
        view.HideSpinner()
        do {
            sleep(5)
        }
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("NotificationLeadList"), object: nil)
    }
    
    func errorReceived(error: String) {
        
    }
    
   private func setUpUI(){
       saveButton.roundCorners(corners: [.allCorners], radius: 10)
       CancelButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    @IBAction func submitButtonClicked() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            nameTextField.showError(message: Constant.CreateLead.firstNameEmptyError)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.CreateLead.emailEmptyError)
            return
        }
        guard let emailIsValid = viewModel?.isValidEmail(email), emailIsValid else {
            emailTextField.showError(message: Constant.CreateLead.emailInvalidError)
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberEmptyError)
            return
        }
        
        guard let phoneNumberIsValid = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberIsValid else {
            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberInvalidError)
            return
        }
        setFirstName()
        setLastName()
        setEmail()
        setPhoneNumber()
        setMessage()
        let patientQuestionAnswers: [String: Any] = [
               "id": 1234,
               "questionnaireId": 7996,
               "source": "Manual",
               "patientQuestionAnswers": patientQuestionAnswers
        ]
        view.ShowSpinner()
        viewModel?.updateLead(questionnaireId: 7996, patientQuestionAnswers: patientQuestionAnswers)
    }
    
    func setFirstName(){
        let patientQuestion: [String : Any] = [
            "questionId": 64792,
            "questionName": "First Name",
            "questionType": "Input",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": nameTextField.text ?? "",
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.insert(patientQuestion, at: 0)
    }
    
    func setLastName(){
//        let patientQuestion: [String : Any] = [
//            "questionId": 64793,
//            "questionName": "Last Name",
//            "questionType": "Input",
//            "allowMultipleSelection": false,
//            "preSelectCheckbox": false,
//            "answer": "",
//            "answerText": lastNameTextField.text ?? "",
//            "answerComments": "",
//            "patientQuestionChoices": [],
//            "required": true,
//            "hidden": false,
//            "showDropDown": false
//        ]
//        patientQuestionAnswers.insert(patientQuestion, at: 1)
    }
    
    func setEmail(){
        let patientQuestion: [String : Any] = [
            "questionId": 64794,
            "questionName": "Email",
            "questionType": "Input",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": emailTextField.text ?? "",
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.insert(patientQuestion, at: 2)
    }
    
    func setPhoneNumber(){
        let patientQuestion: [String : Any] = [
            "questionId": 64795,
            "questionName": "Phone Number",
            "questionType": "Input",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": phoneNumberTextField.text ?? "",
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.insert(patientQuestion, at: 3)
    }
    
    func setMessage(){
//        let patientQuestion: [String : Any] = [
//            "questionId": 64796,
//            "questionName": "Message",
//            "questionType": "Input",
//            "allowMultipleSelection": false,
//            "preSelectCheckbox": false,
//            "answer": "",
//            "answerText": messageTextField.text ?? "",
//            "answerComments": "",
//            "patientQuestionChoices": [],
//            "required": true,
//            "hidden": false,
//            "showDropDown": false
//        ]
//        patientQuestionAnswers.insert(patientQuestion, at: 4)
    }
}
