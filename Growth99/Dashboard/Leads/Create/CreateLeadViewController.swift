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
    @IBOutlet weak var customViewHight : NSLayoutConstraint!

   private var patientQuestionAnswers = Array<Any>()
   private var viewModel: CreateLeadViewModelProtocol?
   private var patientQuestionList = [PatientQuestionAnswersList]()

   private var yPosition  = 20
   private var xPosition  = 30
   private var widthPosition  = 300
   private lazy var inputTypeTextField: CustomTextField = {
        let textField = CustomTextField()
        return textField
    }()


    var buttons = [UIButton]()
    var patientQuestionChoices = [UIButton]()
    
    var buttonLastTag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadViewModel(delegate: self)
        setUpUI()
        self.view.ShowSpinner()
        viewModel?.getQuestionnaireId()
        self.widthPosition = Int((self.view.frame.width - 40))
    }

    func QuestionnaireIdRecived() {
        viewModel?.getQuestionnaireList()
    }
 
    func QuestionnaireListRecived() {
        view.HideSpinner()
        patientQuestionList = viewModel?.leadUserQuestionnaireList ?? []
        self.setUpUiElement()
    }

    func setUpUiElement(){
        var i = 0
        patientQuestionList.forEach { item in
            i += 1
            if item.questionType == "Input" {
                 inputTypeTextField = CustomTextField()
                 let label : UILabel = UILabel()
                 label.text = item.questionName
                 label.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 25)
                 self.customView.addSubview(label)
                 yPosition +=  Int(label.frame.height + 5)
                 inputTypeTextField.tag = i
                 print("Input type", inputTypeTextField.tag)
                 inputTypeTextField.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 40)
                 self.customView.addSubview(inputTypeTextField)
                 yPosition +=  Int(inputTypeTextField.frame.height + 20)
            } else if (item.questionType == "Text") {
                let textView : UITextField = CustomTextField()
                textView.tag = i
                print("Text type", textView.tag)
                textView.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 80)
                self.customView.addSubview(textView)
                yPosition +=  Int(textView.frame.height + 20)
            } else if (item.questionType ==  "Yes_No") {
                let label : UILabel = UILabel()
                print("Yes_No", label.tag)
                label.text = item.questionName
                label.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 40)
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
                MultipleSelectionlabel.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 40)
                self.customView.addSubview(MultipleSelectionlabel)
                yPosition +=  Int(MultipleSelectionlabel.frame.height + 10)
                let posX = 30
                item.patientQuestionChoices?.forEach { item in
                        i += 1
                        let button1 = PassableUIButton(frame: CGRect(x: posX, y: yPosition, width: 100, height: 20))
                        button1.setTitleColor(UIColor.black, for: .normal)
                        let title = " " + (item.choiceName ?? "")
                        button1.setTitle(title , for: .normal)
                        button1.contentHorizontalAlignment = .left
                        button1.setImage(UIImage(named: "tickdefault")!, for: .normal)
                        button1.setImage(UIImage(named: "tickselected")!, for: .selected)
                        button1.addTarget(self, action: #selector(CreateLeadViewController.webButtonTouched(_:)), for:.touchUpInside)
                        button1.tag = i
                        print("multiselcted button", button1.tag)
                        button1.params[i] = item
                        self.customView.addSubview(button1)
                        patientQuestionChoices.append(button1)
                        yPosition +=  Int(button1.frame.height + 10)
                  }
              }
        }
        customViewHight.constant = CGFloat(yPosition + 150)
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
        var inputType: Bool =  false
        var inputTypePresent: Bool =  false
        var TextType: Bool =  false
        var TextTypePresent: Bool =  false

        var i = 0
        patientQuestionList.forEach { item in
            i += 1
           
            if item.questionType == "Input" {
                inputTypePresent = true
                if let inputTypeTxtField = self.customView.viewWithTag(i) as? CustomTextField {
                   
                    guard let txtField = inputTypeTxtField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? "") , isValid else {
                        inputTypeTxtField.showError(message: item.validationMessage)
                        inputType = false
                        return
                    }
                   self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: inputTypeTxtField.text ?? "")
                   inputType = true
               }
            }
           
            if(item.questionType == "Text" ){
                TextTypePresent =  true
                if let txtView = self.customView.viewWithTag(i) as? CustomTextField {
                    if txtView.text == "", let isValid = viewModel?.isValidTextFieldData(txtView.text ?? "", regex: item.regex ?? "") , isValid {
                        txtView.showError(message: item.validationMessage)
                        TextType = false
                        return
                    }
                    self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: txtView.text ?? "")
                    TextType = true

                }
            }
            if(item.questionType == "Yes_No" ){
                if let txtView = self.customView.viewWithTag(i) as? UIButton {
                    self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: txtView.isSelected)
                    print(txtView.isSelected)
                }
            }
            if(item.questionType == "Multiple_Selection_Text" ) {
                var patientQuestionChoicesList: [Any] = []
                for item in item.patientQuestionChoices ?? [] {
                    i += 1
                    if let passableUIButton = self.customView.viewWithTag(i) as? PassableUIButton {
                        let list  = self.patientQuestionChoicesList(patientQuestionChoices: item, selected: passableUIButton.isSelected)
                        patientQuestionChoicesList.append(list)
                    }
                }
                self.setPatientQuestionChoicesList(patientQuestionAnswersList: item, patientQuestionList: patientQuestionChoicesList)
            }
        }
            let patientQuestionAnswers: [String: Any] = [
                "id": 1234,
                "questionnaireId": 7996,
                "source": "Manual",
                "patientQuestionAnswers": patientQuestionAnswers
            ]
            if TextTypePresent || inputTypePresent {
                if inputType == true || TextType == true {
                    view.ShowSpinner()
                    viewModel?.createLead(patientQuestionAnswers: patientQuestionAnswers)
                    print("all condtion meet")
                }
            }
    }
    
    func patientQuestionChoicesList(patientQuestionChoices : PatientQuestionChoices, selected : Bool) -> [String : Any] {
         let patientQuestionChoices: [String : Any] = [
                "choiceName": patientQuestionChoices.choiceName ?? 0,
                "choiceId": patientQuestionChoices.choiceId ?? 0,
                "selected": selected
            ]
        return patientQuestionChoices
    }
    
    
    func setPatientQuestionChoicesList(patientQuestionAnswersList : PatientQuestionAnswersList, patientQuestionList: [Any]){
       
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? "",
            "questionType": patientQuestionAnswersList.questionType ?? "",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": patientQuestionAnswersList.answerText ?? "",
            "answerComments": "",
            "patientQuestionChoices": patientQuestionList,
            "required": true,
            "hidden": false,
            "showDropDown": false
        ]
        patientQuestionAnswers.append(patientQuestion)
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

//extension CreateLeadViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag - 1)
//
//        guard let txtField = textField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: leadVM?.regex ?? "") , isValid else {
//            inputTypeTextField.tag.showError(message: leadVM?.validationMessage)
//            return false
//        }
//        return true
//    }
////    func textFieldDidBeginEditing(_ textField: UITextField) {
////        let leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
////
////        if textField.text == "", !(viewModel?.isValidTextFieldData(textField.text ?? "", regex: leadVM?.regex ?? "") ?? false) {
////            //inputTextField.showError(message: leadVM?.validationMessage)
////        }
////    }
////
////    func textFieldDidEndEditing(_ textField: UITextField) {
////        var leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
////        leadVM?.answerText = textField.text
////
////    }
//}
