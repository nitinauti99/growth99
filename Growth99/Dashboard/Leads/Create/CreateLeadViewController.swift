//
//  CreateLeadViewController.swift
//  Growth99
//
//  Created by nitin auti on 04/12/22.
//

import Foundation
import UIKit

protocol CreateLeadViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class CreateLeadViewController: UIViewController, leadViewControllerProtocol {
    
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var messageTextField: CustomTextField!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!

    var patientQuestionAnswers = Array<Any>()
    var viewModel: CreateLeadViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadViewModel(delegate: self)
        setUpUI()
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
       submitButton.roundCorners(corners: [.allCorners], radius: 10)
       CancelButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitButtonClicked() {
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
        viewModel?.createLead(questionnaireId: 7996, patientQuestionAnswers: patientQuestionAnswers)
    }
    
    func setFirstName(){
        let patientQuestion: [String : Any] = [
            "questionId": 64792,
            "questionName": "First Name",
            "questionType": "Input",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": firstNameTextField.text ?? "",
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.insert(patientQuestion, at: 0)
    }
    
    func setLastName(){
        let patientQuestion: [String : Any] = [
            "questionId": 64793,
            "questionName": "Last Name",
            "questionType": "Input",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": lastNameTextField.text ?? "",
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.insert(patientQuestion, at: 1)
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
        let patientQuestion: [String : Any] = [
            "questionId": 64796,
            "questionName": "Message",
            "questionType": "Input",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": messageTextField.text ?? "",
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.insert(patientQuestion, at: 4)
    }
}

