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

    var yPosition  = 20
    var buttons = [UIButton]()
    var patientQuestionChoices = [UIButton]()
    
    var buttonLastTag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadViewModel(delegate: self)
        setUpUI()
        self.view.ShowSpinner()
        viewModel?.getQuestionnaireId()
       // self.reegisterCell()
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
      //  leadListTableView.reloadData()
        self.setUpUiElement()
    }

    func setUpUiElement(){
        var i = 0
        patientQuestionList.forEach { item in
            i += 1
            if item.questionType == "Input" {
                 let textField: UITextField = CustomTextField()
                 textField.tag = i
                 print("Input type", textField.tag)
                 textField.frame = CGRect(x: 20, y: yPosition, width: 300, height: 40)
                 self.customView.addSubview(textField)
                 yPosition +=  Int(textField.frame.height + 20)
            } else if (item.questionType == "Text") {
                let textView : UITextField = CustomTextField()
                textView.tag = i
                print("Text type", textView.tag)
                textView.frame = CGRect(x: 20, y: yPosition, width: 300, height: 80)
                self.customView.addSubview(textView)
                yPosition +=  Int(textView.frame.height + 20)
            } else if (item.questionType ==  "Yes_No") {
                let label : UILabel = UILabel()
                print("Yes_No", label.tag)
                label.text = item.questionName
                label.frame = CGRect(x: 20, y: yPosition, width: 300, height: 40)
                self.customView.addSubview(label)
                yPosition +=  Int(label.frame.height + 10)
                let posX = 20
                let button1 = UIButton(frame: CGRect(x: posX, y: yPosition, width: 70, height: 20))
                button1.setTitleColor(UIColor.black, for: .normal)
                button1.setTitle("  YES", for: .normal)
                button1.setImage(UIImage(named: "tickdefault")!, for: .normal)
                button1.setImage(UIImage(named: "tickselected")!, for: .selected)
                button1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button1.tag = i
                self.customView.addSubview(button1)
                buttons.append(button1)

                let button2 = UIButton(frame: CGRect(x: Int(button1.frame.width)  + posX, y: yPosition, width: 70, height: 20))
                button2.setTitleColor(UIColor.black, for: .normal)
                button2.setTitle("  NO", for: .normal)
                button2.setImage(UIImage(named: "tickdefault")!, for: .normal)
                button2.setImage(UIImage(named: "tickselected")!, for: .selected)
                button2.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button2.tag = i
                self.customView.addSubview(button2)
                buttons.append(button2)
                yPosition +=  Int(button2.frame.height + 20)

            } else if (item.questionType == "Multiple_Selection_Text") {
                let MultipleSelectionlabel : UILabel = UILabel()
                print("Yes_No", MultipleSelectionlabel.tag)
                MultipleSelectionlabel.text = item.questionName
                MultipleSelectionlabel.frame = CGRect(x: 20, y: yPosition, width: 300, height: 40)
                self.customView.addSubview(MultipleSelectionlabel)
                yPosition +=  Int(MultipleSelectionlabel.frame.height + 10)
                let posX = 20
                item.patientQuestionChoices?.forEach { item in
                        let button1 = PassableUIButton(frame: CGRect(x: posX, y: yPosition, width: 100, height: 20))
                        button1.setTitleColor(UIColor.black, for: .normal)
                        let title = " " + (item.choiceName ?? "")
                        button1.setTitle(title , for: .normal)
                        button1.contentHorizontalAlignment = .left
                        button1.setImage(UIImage(named: "tickdefault")!, for: .normal)
                        button1.setImage(UIImage(named: "tickselected")!, for: .selected)
                        button1.addTarget(self, action: #selector(CreateLeadViewController.webButtonTouched(_:)), for:.touchUpInside)
                        button1.tag = i
                        button1.params[i] = item
                        self.customView.addSubview(button1)
                        patientQuestionChoices.append(button1)
                        yPosition +=  Int(button1.frame.height + 10)
                  }
              }
        }
    }
   
    @IBAction func webButtonTouched(_ sender: PassableUIButton) {
        print(sender.params[sender.tag] ?? "")
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "tickdefault")!, for: .normal)
        }else{
            sender.isSelected = true
            sender.setImage(UIImage(named: "tickselected")!, for: .selected)
        }
    }
    
   
   
    @objc func buttonAction(sender: UIButton!){
        let buttonIndex = buttons.index(of: sender)
        print(buttonIndex)
        sender.isSelected = true

//        if buttonLastTag == sender.tag {
//            buttonLastTag = sender.tag
//            for button in buttons {
//                button.isSelected = false
//            }
//            sender.isSelected = true
//        } else {
//            buttonLastTag = sender.tag
//            for button in buttons {
//                button.isSelected = false
//            }
//            sender.isSelected = true
//        }
    }
    
    @objc func button2Action(sender: UIButton!){
         if sender.isSelected {
            sender.isSelected = false
          } else {
            sender.isSelected = true
          }
        // you may need to know which button to trigger some action
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
      if let cell = textField.next(ofType: InputTypeTableViewCell.self) {

        if textField.text == "", !cell.isValidTextFieldData(textField.text ?? "", regex: leadVM?.regex ?? "") {
            cell.inputTextField.showError(message: leadVM?.validationMessage)
        }
      }
    }
    
    @IBAction func submitButtonClicked() {
        var i = 0
        patientQuestionList.forEach { item in
            i += 1
            if item.questionType == "Input" {
                if let txtField = self.customView.viewWithTag(i) as? CustomTextField {
                    if txtField.text == "" {
                        txtField.showError(message: item.validationMessage)
                    }
                    self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: txtField.text ?? "")
                    print(txtField.text!)
                }
            } else if(item.questionType == "Text" ){
                if let txtView = self.customView.viewWithTag(i) as? CustomTextField {
                    if txtView.text == "" {
                        txtView.showError(message: item.validationMessage)
                    }
                    self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: txtView.text ?? "")
                    print(txtView.text!)
              }
            }
            
            else if(item.questionType == "Yes_No" ){
                if let txtView = self.customView.viewWithTag(i) as? UIButton {
                    self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: txtView.isSelected)
                    print(txtView.isSelected)
              }
            } else if(item.questionType == "Multiple_Selection_Text" ){
                if let passableUIButton = self.customView.viewWithTag(i) as? PassableUIButton {
                    var pationt = item.patientQuestionChoices?[i]
                    pationt?.selected = passableUIButton.isSelected
                   self.setPatientQuestionChoicesList(patientQuestionAnswersList: item, answerText: passableUIButton.isSelected)
                }
            }
         }
        print(patientQuestionAnswers)
        let patientQuestionAnswers: [String: Any] = [
               "id": 1234,
               "questionnaireId": 7996,
               "source": "Manual",
               "patientQuestionAnswers": patientQuestionAnswers
        ]
        view.ShowSpinner()
        viewModel?.createLead(patientQuestionAnswers: patientQuestionAnswers)
    }
    
    
    func setPatientQuestionChoicesList(patientQuestionAnswersList : PatientQuestionAnswersList, answerText: Bool){
       
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? "",
            "questionType": patientQuestionAnswersList.questionType ?? "",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": answerText,
            "answerComments": "",
            "patientQuestionChoices": setPatientQuestionChoicesList(patientQuestionChoices: patientQuestionAnswersList.patientQuestionChoices ?? [], selected: answerText),
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
    
    func setPatientQuestionChoicesList(patientQuestionChoices : [PatientQuestionChoices], selected : Bool) -> [Any] {
        var patientQuestionChoicesList: [Any] = []

        for item in patientQuestionChoices {
            let patientQuestionChoices: [String : Any] = [
                "choiceName": item.choiceName ?? 0,
                "choiceId": item.choiceId ?? 0,
                "selected": selected
            ]
            patientQuestionChoicesList.append(patientQuestionChoices)
        }
        return patientQuestionChoicesList
    }
    
    func setPatientQuestionList(patientQuestionAnswersList : PatientQuestionAnswersList, answerText: String){
       
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? "",
            "questionType": patientQuestionAnswersList.questionType ?? "",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": answerText,
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
  
    func setPatientQuestionListForBool(patientQuestionAnswersList : PatientQuestionAnswersList, answerText: Bool){
       
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? "",
            "questionType": patientQuestionAnswersList.questionType ?? "",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": answerText,
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.append(patientQuestion)
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

//        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
//            firstNameTextField.showError(message: Constant.CreateLead.firstNameEmptyError)
//            return
//        }
//
//        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
//            lastNameTextField.showError(message: Constant.CreateLead.lastNameEmptyError)
//            return
//        }
//
//        guard let email = emailTextField.text, !email.isEmpty else {
//            emailTextField.showError(message: Constant.CreateLead.emailEmptyError)
//            return
//        }
//        guard let emailIsValid = viewModel?.isValidEmail(email), emailIsValid else {
//            emailTextField.showError(message: Constant.CreateLead.emailInvalidError)
//            return
//        }
//
//        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
//            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberEmptyError)
//            return
//        }
//
//        guard let phoneNumberIsValid = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberIsValid else {
//            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberInvalidError)
//            return
//        }
//        setFirstName()
//        setLastName()
//        setEmail()
//        setPhoneNumber()
//        setMessage()
