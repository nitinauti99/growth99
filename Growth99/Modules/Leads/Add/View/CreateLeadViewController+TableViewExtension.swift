//
//  CreateLeadViewController+TableViewExtension.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

extension CreateLeadViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientQuestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let item = patientQuestionList[indexPath.row]
        print("drop down", item.showDropDown ?? false)
        
        if item.questionType == "Input" {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "InputTypeTableViewCell") as? InputTypeTableViewCell else { return UITableViewCell() }

            cell.inputeTypeLbi.text = item.questionName
            return cell

        }
        if(item.questionType == "Text") {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "TextTypeTableViewCell") as? TextTypeTableViewCell else { return UITableViewCell() }
            cell.textTypeLbi.text = item.questionName
            return cell

        }
        if(item.questionType == "Yes_No") {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "YesNoTypeTableViewCell") as? YesNoTypeTableViewCell else { return UITableViewCell() }
            cell.yesNoTypeLbi.text = item.questionName
            return cell

        }
        if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == true) {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTextTypeTableViewCell") as? MultipleSelectionTextTypeTableViewCell else { return UITableViewCell() }

            cell.inputeTypeLbi.text = item.questionName
            var buttonY = 40
            for item in item.patientQuestionChoices ?? [] {
                    let button1 = PassableUIButton(frame: CGRect(x: 30, y: buttonY, width: 100, height: 20))
                    button1.setTitleColor(UIColor.black, for: .normal)
                    let title = " " + (item.choiceName ?? "")
                    button1.setTitle(title , for: .normal)
                    button1.contentHorizontalAlignment = .left
                    button1.setImage(UIImage(named: "tickdefault")!, for: .normal)
                    button1.setImage(UIImage(named: "tickselected")!, for: .selected)
                    button1.addTarget(self, action: #selector(CreateLeadViewController.webButtonTouched(_:)), for:.touchUpInside)
                    button1.tag = k
                    print("multiselcted button", button1.tag)
                    buttonY +=  Int(button1.frame.height + 10)
                    cell.contentView.addSubview(button1)
                    k += 1
                }
           return cell

        }
        if(item.questionType == "Multiple_Selection_Text" && item.showDropDown == true) {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell") as? MultipleSelectionWithDropDownTypeTableViewCell else { return UITableViewCell() }
            listArray = []
            cell.dropDownTypeLbi.text = item.questionName
            listArray = item.patientQuestionChoices ?? []
            cell.dropDownTypeTextField.addTarget(self, action: #selector(Self.textFieldDidChange(_:)), for: .touchDown)
            return cell
       
        }
        if(item.questionType == "Multiple_Selection_Text" && item.preSelectCheckbox == true) {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "PreSelectCheckboxTableViewCell") as? PreSelectCheckboxTableViewCell else { return UITableViewCell() }
            cell.preSelectCheckbox.text = item.questionName
            return cell
        }
        
        if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == false) {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTextWithFalseTableViewCell") as? MultipleSelectionTextWithFalseTableViewCell else { return UITableViewCell() }

            cell.multipleSelectionTypeLbi.text = item.questionName
            var buttonY = 40
            for item in item.patientQuestionChoices ?? [] {
                    let button1 = PassableUIButton(frame: CGRect(x: 30, y: buttonY, width: 100, height: 20))
                    button1.setTitleColor(UIColor.black, for: .normal)
                    let title = " " + (item.choiceName ?? "")
                    button1.setTitle(title , for: .normal)
                    button1.contentHorizontalAlignment = .left
                    button1.setImage(UIImage(named: "tickdefault")!, for: .normal)
                    button1.setImage(UIImage(named: "tickselected")!, for: .selected)
                    button1.addTarget(self, action: #selector(CreateLeadViewController.buttonAction(_ :)), for:.touchUpInside)
                    button1.tag = j
                    print("multiselcted false button", button1.tag)
                    buttonY +=  Int(button1.frame.height + 10)
                    cell.contentView.addSubview(button1)
                    buttons.insert(button1, at: j)
                    j += 1
                }
           return cell
        }
        if(item.questionType == "Date") {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "DateTypeTableViewCell") as? DateTypeTableViewCell else { return UITableViewCell() }
            cell.dateTypeLbi.text = item.questionName
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = patientQuestionList[indexPath.row]

        if item.questionType == "Input" {
            return 100
        }else if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == true){
            return CGFloat((item.patientQuestionChoices?.count ?? 0) * 30 + 60)
        }else if(item.questionType == "Multiple_Selection_Text" && item.showDropDown == true) {
            return 120
        }else if(item.questionType == "Multiple_Selection_Text" && item.preSelectCheckbox == true) {
            return 60
        }else if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == false) {
            return CGFloat((item.patientQuestionChoices?.count ?? 0) * 30 + 60)
        }else{
            return 100
        }
    }
    
}

//    @IBAction func submitButtonClicked() {
//        var inputType: Bool =  false
//        var inputTypePresent: Bool =  false
//        var TextType: Bool =  false
//        var TextTypePresent: Bool =  false
//        var dateTypePresent: Bool = false
//        var dateType: Bool = false
//
//        var i = 0
//        patientQuestionList.forEach { item in
//            i += 1
//            if item.questionType == "Input" {
//                inputTypePresent = true
//                if let inputTypeTxtField = self.customView.viewWithTag(i) as? CustomTextField {
//                    guard let txtField = inputTypeTxtField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? "") , isValid else {
//                        inputTypeTxtField.showError(message: item.validationMessage)
//                        inputType = false
//                        return
//                    }
//                   self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: inputTypeTxtField.text ?? "")
//                   inputType = true
//               }
//            }
//
//            if(item.questionType == "Text" ){
//                TextTypePresent =  true
//                if let txtView = self.customView.viewWithTag(i) as? CustomTextField {
//                    if txtView.text == "", let isValid = viewModel?.isValidTextFieldData(txtView.text ?? "", regex: item.regex ?? "") , isValid {
//                        txtView.showError(message: item.validationMessage)
//                        TextType = false
//                        return
//                    }
//                    self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: txtView.text ?? "")
//                    TextType = true
//
//                }
//            }
//            if(item.questionType == "Yes_No" ){
//                if let txtView = self.customView.viewWithTag(i) as? UIButton {
//                    self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: txtView.isSelected)
//                    print(txtView.isSelected)
//                }
//            }
//            if(item.questionType == "Multiple_Selection_Text" ) {
//                var patientQuestionChoicesList: [Any] = []
//                for item in item.patientQuestionChoices ?? [] {
//                    i += 1
//                    if let passableUIButton = self.customView.viewWithTag(i) as? PassableUIButton {
//                        let list  = self.patientQuestionChoicesList(patientQuestionChoices: item, selected: passableUIButton.isSelected)
//                        patientQuestionChoicesList.append(list)
//                    }
//                }
//                self.setPatientQuestionChoicesList(patientQuestionAnswersList: item, patientQuestionList: patientQuestionChoicesList)
//            }
//            if (item.questionType == "Date") {
//                dateTypePresent = true
//                if let inputTypeTxtField = self.customView.viewWithTag(i) as? CustomTextField {
//                    guard let txtField = inputTypeTxtField.text, txtField != "" else {
//                        if item.validationMessage == nil {
//                            inputTypeTxtField.showError(message: "The date selection field is required.")
//                        }else{
//                            inputTypeTxtField.showError(message: item.validationMessage)
//                        }
//                        dateType = false
//                        return
//                    }
//                   self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: inputTypeTxtField.text ?? "")
//                    dateType = true
//               }
//            }
//        }
//            let patientQuestionAnswers: [String: Any] = [
//                "id": 1234,
//                "questionnaireId": 7996,
//                "source": "Manual",
//                "patientQuestionAnswers": patientQuestionAnswers
//            ]
//
//           if TextTypePresent || inputTypePresent || dateTypePresent{
//                if inputType == true || TextType == true || dateType == true {
//                    view.ShowSpinner()
//                    viewModel?.createLead(patientQuestionAnswers: patientQuestionAnswers)
//                    print("all condtion meet")
//                }
//            }
//    }
//    func setUpUiElement(){
//        var i = 0
//
//        patientQuestionList.forEach { item in
//            i += 1
//
//            if item.questionType == "Input" {
//                 inputTypeTextField = CustomTextField()
//                 let label : UILabel = UILabel()
//                 label.text = item.questionName
//                 label.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 25)
//                 self.customView.addSubview(label)
//                 yPosition +=  Int(label.frame.height + 5)
//                 inputTypeTextField.tag = i
//                 print("Input type", inputTypeTextField.tag)
//                 inputTypeTextField.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 40)
//                 self.customView.addSubview(inputTypeTextField)
//                 yPosition +=  Int(inputTypeTextField.frame.height + 20)
//
//            } else if (item.questionType == "Text") {
//                let textView : UITextField = CustomTextField()
//                textView.tag = i
//                print("Text type", textView.tag)
//                textView.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 80)
//                self.customView.addSubview(textView)
//                yPosition +=  Int(textView.frame.height + 20)
//
//            } else if (item.questionType ==  "Yes_No") {
//                let label : UILabel = UILabel()
//                print("Yes_No", label.tag)
//                label.text = item.questionName
//                label.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 40)
//                self.customView.addSubview(label)
//                yPosition +=  Int(label.frame.height + 10)
//
//                let button1 = UIButton(frame: CGRect(x: 20, y: yPosition, width: 70, height: 20))
//                button1.setTitleColor(UIColor.black, for: .normal)
//                button1.setTitle("  YES", for: .normal)
//                button1.setImage(UIImage(named: "tickdefault")!, for: .normal)
//                button1.setImage(UIImage(named: "tickselected")!, for: .selected)
//                button1.addTarget(self, action: #selector(btnOnlineAction), for: .touchUpInside)
//                button1.tag = i
//
//                let button2 = UIButton(frame: CGRect(x: Int(button1.frame.width) + 10, y: yPosition, width: 70, height: 20))
//                button2.setTitleColor(UIColor.black, for: .normal)
//                button2.setTitle("  NO", for: .normal)
//                button2.setImage(UIImage(named: "tickdefault")!, for: .normal)
//                button2.setImage(UIImage(named: "tickselected")!, for: .selected)
//                button2.addTarget(self, action: #selector(btnCodAction), for: .touchUpInside)
//                button2.tag = i
//
//                self.customView.addSubview(button1)
//                self.customView.addSubview(button2)
//                yPosition +=  Int(button2.frame.height + 20)
//
//            } else if (item.questionType == "Multiple_Selection_Text") {
//                let MultipleSelectionlabel : UILabel = UILabel()
//                print("Yes_No", MultipleSelectionlabel.tag)
//                MultipleSelectionlabel.text = item.questionName
//                MultipleSelectionlabel.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 40)
//                self.customView.addSubview(MultipleSelectionlabel)
//                yPosition +=  Int(MultipleSelectionlabel.frame.height + 10)
//                let posX = 30
//                item.patientQuestionChoices?.forEach { item in
//                        i += 1
//                        let button1 = PassableUIButton(frame: CGRect(x: posX, y: yPosition, width: 100, height: 20))
//                        button1.setTitleColor(UIColor.black, for: .normal)
//                        let title = " " + (item.choiceName ?? "")
//                        button1.setTitle(title , for: .normal)
//                        button1.contentHorizontalAlignment = .left
//                        button1.setImage(UIImage(named: "tickdefault")!, for: .normal)
//                        button1.setImage(UIImage(named: "tickselected")!, for: .selected)
//                        button1.addTarget(self, action: #selector(CreateLeadViewController.webButtonTouched(_:)), for:.touchUpInside)
//                        button1.tag = i
//                        print("multiselcted button", button1.tag)
//                        button1.params[i] = item
//                        self.customView.addSubview(button1)
//                        yPosition +=  Int(button1.frame.height + 10)
//                  }
//                yPosition +=  Int(20)
//
//            } else if (item.questionType == "Date") {
//                inputTypeTextField = CustomTextField()
//                let label : UILabel = UILabel()
//                label.text = item.questionName
//                label.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 25)
//                self.customView.addSubview(label)
//                yPosition +=  Int(label.frame.height + 5)
//                inputTypeTextField.tag = i
//                print("Input type", inputTypeTextField.tag)
//                inputTypeTextField.frame = CGRect(x: xPosition, y: yPosition, width: self.widthPosition, height: 40)
//                let datePicker = UIDatePicker()
//                datePicker.datePickerMode = .date
//                datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
//                datePicker.frame.size = CGSize(width: 0, height: 300)
//                if #available(iOS 13.4, *) {
//                    datePicker.preferredDatePickerStyle = .wheels
//                } else {
//                    // Fallback on earlier versions
//                }
//                datePicker.minimumDate = Date()
//                datePicker.tag = inputTypeTextField.tag
//                let toolBar = UIToolbar()
//                toolBar.barStyle = UIBarStyle.default
//                toolBar.isTranslucent = true
//                toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//                toolBar.sizeToFit()
//                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
//                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//                let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.donePicker))
//
//                toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//                toolBar.isUserInteractionEnabled = true
//                doneButton.tag = inputTypeTextField.tag
//                cancelButton.tag = inputTypeTextField.tag
//                inputTypeTextField.inputView = datePicker
//                inputTypeTextField.inputAccessoryView = toolBar
//                self.customView.addSubview(inputTypeTextField)
//                yPosition +=  Int(inputTypeTextField.frame.height + 20)
//            }
//        }
//        customViewHight.constant = CGFloat(yPosition + 150)
//    }

//    @objc func donePicker( _ sender: UIBarButtonItem) {
//        if let inputTypeTxtField = self.customView.viewWithTag(sender.tag) as? CustomTextField {
//            inputTypeTxtField.resignFirstResponder()
//         }
//    }
//
//     @objc func dateChange(datePicker: UIDatePicker) {
//         if let inputTypeTxtField = self.customView.viewWithTag(datePicker.tag) as? CustomTextField {
//             inputTypeTxtField.text = formatDate(date: datePicker.date)
//          }
//     }
//
//    func formatDate(date: Date) -> String  {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        return formatter.string(from: date)
//    }
//


//    @IBAction func btnOnlineAction(_ sender: UIButton) {
//        if sender.isSelected {
//            sender.isSelected = false
//            sender.setImage(UIImage(named: "tickdefault")!, for: .normal)
//            if let button = self.customView.viewWithTag(sender.tag + 1) as? UIButton {
//                button.setImage(UIImage(named: "tickselected")!, for: .selected)
//                button.isSelected = true
//            }
//        } else {
//            sender.setImage(UIImage(named: "tickselected")!, for: .selected)
//            sender.isSelected = true
//            if let button = self.customView.viewWithTag(sender.tag + 1) as? UIButton {
//                button.setImage(UIImage(named: "tickdefault")!, for: .normal)
//                button.isSelected = false
//            }
//        }
//    }
//
//
//    @IBAction func btnCodAction(_ sender: UIButton) {
//        if sender.isSelected {
//            sender.isSelected = false
//            sender.setImage(UIImage(named: "tickdefault")!, for: .normal)
//            if let button = self.customView.viewWithTag(sender.tag - 1) as? UIButton {
//                button.setImage(UIImage(named: "tickselected")!, for: .selected)
//                button.isSelected = true
//            }
//        } else {
//            sender.setImage(UIImage(named: "tickselected")!, for: .selected)
//            sender.isSelected = true
//            if let button = self.customView.viewWithTag(sender.tag - 1) as? UIButton {
//                button.setImage(UIImage(named: "tickdefault")!, for: .normal)
//                button.isSelected = false
//            }
//        }
//    }
    
