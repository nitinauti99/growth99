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
    func QuestionnaireIdRecived()
    func QuestionnaireListRecived()
    func errorReceived(error: String)
}

class CreateLeadViewController: UIViewController, CreateLeadViewControllerProtocol {
    
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var messageTextField: CustomTextField!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!
    @IBOutlet weak var customView : UIView!
    @IBOutlet weak var leadListTableView : UITableView!

   private var patientQuestionAnswers = Array<Any>()
   private var viewModel: CreateLeadViewModelProtocol?
   private var patientQuestionList = [PatientQuestionAnswersList]()

    var txtField: UITextField = CustomTextField()
    var yPosition  = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadViewModel(delegate: self)
        setUpUI()
        self.view.ShowSpinner()
        viewModel?.getQuestionnaireId()
        self.reegisterCell()
    }
    
    func reegisterCell() {
        leadListTableView.register(UINib(nibName: "InputTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTypeTableViewCell")
    }
    
    func QuestionnaireIdRecived() {
        viewModel?.getQuestionnaireList()
    }
 
    func QuestionnaireListRecived() {
        view.HideSpinner()
        patientQuestionList = viewModel?.leadUserQuestionnaireList ?? []
        leadListTableView.reloadData()
      //  self.setUpUiElement()
    }

//    func setUpUiElement(){
//        for item in patientQuestionList {
//            if item.questionType == "Input" {
//                self.txtField.frame = CGRect(x: 20, y: yPosition, width: 300, height: 40)
//                self.customView.addSubview(self.txtField)
//                yPosition = yPosition +  Int(self.txtField.frame.height + 20)
//            }
//        }
//
//    }
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
      if let cell = textField.next(ofType: InputTypeTableViewCell.self) {

        if textField.text == "", !cell.isValidTextFieldData(textField.text ?? "", regex: leadVM?.regex ?? "") {
            cell.inputTextField.showError(message: leadVM?.validationMessage)
        }
      }
    }
    
    @IBAction func submitButtonClicked() {
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            firstNameTextField.showError(message: Constant.CreateLead.firstNameEmptyError)
            return
        }
        
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameTextField.showError(message: Constant.CreateLead.lastNameEmptyError)
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
        viewModel?.createLead(patientQuestionAnswers: patientQuestionAnswers)
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


extension CreateLeadViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientQuestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let item = patientQuestionList[indexPath.row]
        if item.questionType == "Input" {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "InputTypeTableViewCell") as? InputTypeTableViewCell else {
                return UITableViewCell()
            }
            cell1.configureCell(leadVM: viewModel, index: indexPath, tableview: leadListTableView)
            return cell1

        } else if item.questionType == "Text" {
            cell.contentView.backgroundColor = .red

        } else if item.questionType == "Date" {
            cell.contentView.backgroundColor = .orange

        } else if item.questionType == "Yes_No" {
            cell.contentView.backgroundColor = .gray

        } else if item.questionType == "Multiple_Selection_Text" {
            cell.contentView.backgroundColor = .green
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = patientQuestionList[indexPath.row]
        if item.questionType == "Input" {
            return 130
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = patientQuestionList[indexPath.row]
        if item.questionType == "Input" {
            let cell = leadListTableView.cellForRow(at: indexPath) as! InputTypeTableViewCell
        }
    }
}
