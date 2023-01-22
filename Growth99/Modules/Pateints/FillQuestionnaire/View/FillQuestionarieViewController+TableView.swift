//
//  FillQuestionarieViewController+TableView.swift
//  Growth99
//
//  Created by nitin auti on 22/01/23.
//
import UIKit

extension FillQuestionarieViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientQuestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let item = patientQuestionList[indexPath.row]
        print("drop down", item.showDropDown ?? false)
        print("questionName ---", item.questionName ?? "")

        if item.questionType == "Input" {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "InputTypeTableViewCell") as? InputTypeTableViewCell else { return UITableViewCell() }

            cell.inputeTypeLbi.text = item.questionName
            return cell

        }
        if(item.questionType == "Text") {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "TextTypeTableViewCell") as? TextTypeTableViewCell else { return UITableViewCell() }
            cell.textTypeLbi.text = item.questionName
            return cell

        }
        if(item.questionType == "Yes_No") {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "YesNoTypeTableViewCell") as? YesNoTypeTableViewCell else { return UITableViewCell() }
            cell.yesNoTypeLbi.text = item.questionName
            return cell

        }
        if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == true) {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTextTypeTableViewCell") as? MultipleSelectionTextTypeTableViewCell else { return UITableViewCell() }

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
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell") as? MultipleSelectionWithDropDownTypeTableViewCell else { return UITableViewCell() }
            listArray = []
            cell.dropDownTypeLbi.text = item.questionName
            listArray = item.patientQuestionChoices ?? []
            cell.dropDownTypeTextField.addTarget(self, action: #selector(Self.textFieldDidChange(_:)), for: .touchDown)
            return cell
       
        }
        if(item.questionType == "Multiple_Selection_Text" && item.preSelectCheckbox == true) {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "PreSelectCheckboxTableViewCell") as? PreSelectCheckboxTableViewCell else { return UITableViewCell() }
            cell.preSelectCheckbox.text = item.questionName
            return cell
        }
        
        if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == false) {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTextWithFalseTableViewCell") as? MultipleSelectionTextWithFalseTableViewCell else { return UITableViewCell() }

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
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "DateTypeTableViewCell") as? DateTypeTableViewCell else { return UITableViewCell() }
            cell.dateTypeLbi.text = item.questionName
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = patientQuestionList[indexPath.row]

        if item.questionType == "Input" {
            return UITableView.automaticDimension
        }else if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == true){
            return CGFloat((item.patientQuestionChoices?.count ?? 0) * 30 + 60)
        }else if(item.questionType == "Multiple_Selection_Text" && item.showDropDown == true) {
            return UITableView.automaticDimension
        }else if(item.questionType == "Multiple_Selection_Text" && item.preSelectCheckbox == true) {
            return UITableView.automaticDimension
        }else if(item.questionType == "Multiple_Selection_Text" && item.allowMultipleSelection == false) {
            return CGFloat((item.patientQuestionChoices?.count ?? 0) * 30 + 60)
        }else if item.questionType == "Yes_No"{
            return UITableView.automaticDimension
        }else if item.questionType == "Text"{
            return UITableView.automaticDimension
        }
      return UITableView.automaticDimension
    }
}
