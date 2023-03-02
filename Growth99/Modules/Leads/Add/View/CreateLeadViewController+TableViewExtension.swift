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

            cell.questionnaireName.text = item.questionName
            return cell

        }
        if(item.questionType == "Text") {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "TextTypeTableViewCell") as? TextTypeTableViewCell else { return UITableViewCell() }
            cell.questionnaireName.text = item.questionName
            return cell

        }
        if(item.questionType == "Yes_No") {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "YesNoTypeTableViewCell") as? YesNoTypeTableViewCell else { return UITableViewCell() }
            cell.questionnaireName.text = item.questionName
            return cell

        }
        if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == true) {
            guard let cell = createLeadTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTextTypeTableViewCell") as? MultipleSelectionTextTypeTableViewCell else { return UITableViewCell() }

            cell.questionnaireName.text = item.questionName
            var buttonY = 40
            for item in item.patientQuestionChoices ?? [] {
                    let button1 = PassableUIButton(frame: CGRect(x: 30, y: buttonY, width: 100, height: 20))
                    button1.setTitleColor(UIColor.black, for: .normal)
                    let title = " " + (item.choiceName ?? String.blank)
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
            cell.questionnaireName.text = item.questionName
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
                    let title = " " + (item.choiceName ?? String.blank)
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
            cell.questionnaireName.text = item.questionName
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
