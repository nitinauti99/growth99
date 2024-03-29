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
    
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!
    @IBOutlet weak var customView : UIView!
    
    @IBOutlet weak var createLeadTableView : UITableView!
    @IBOutlet weak var customViewHight : NSLayoutConstraint!
    private var viewModel: CreateLeadViewModelProtocol?
    private var patientQuestionAnswers = Array<Any>()
    var buttons = [UIButton]()
    var patientQuestionList = [PatientQuestionAnswersList]()
    var listArray = [PatientQuestionChoices]()
    var k = 0
    var j = 0
    
    private lazy var inputTypeTextField: CustomTextField = {
        let textField = CustomTextField()
        return textField
    }()
    
    private var tableViewHeight: CGFloat {
        createLeadTableView.layoutIfNeeded()
        return createLeadTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadViewModel(delegate: self)
        self.view.ShowSpinner()
        viewModel?.getQuestionnaireId()
        setUpUI()
        self.registerTableViewCell()
    }
    
    
    private func setUpUI(){
        submitButton.roundCorners(corners: [.allCorners], radius: 10)
        CancelButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    func registerTableViewCell(){
        createLeadTableView.register(UINib(nibName: "InputTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTypeTableViewCell")
        
        createLeadTableView.register(UINib(nibName: "TextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTypeTableViewCell")
        
        createLeadTableView.register(UINib(nibName: "YesNoTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "YesNoTypeTableViewCell")
        
        createLeadTableView.register(UINib(nibName: "MultipleSelectionTextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextTypeTableViewCell")
        
        createLeadTableView.register(UINib(nibName: "DateTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTypeTableViewCell")
        
        createLeadTableView.register(UINib(nibName: "MultipleSelectionWithDropDownTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell")
        
        createLeadTableView.register(UINib(nibName: "MultipleSelectionTextWithFalseTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextWithFalseTableViewCell")
        
        createLeadTableView.register(UINib(nibName: "PreSelectCheckboxTableViewCell", bundle: nil), forCellReuseIdentifier: "PreSelectCheckboxTableViewCell")
    }
    
    /// api Call
    func QuestionnaireIdRecived() {
        viewModel?.getQuestionnaireList()
    }
    
    /// recvied QuestionnaireList
    func QuestionnaireListRecived() {
        view.HideSpinner()
        patientQuestionList = viewModel?.leadUserQuestionnaireList ?? []
        self.createLeadTableView.reloadData()
        customViewHight.constant = tableViewHeight + 180
    }
    
    /// multiple selection false type buttton action
    @IBAction func webButtonTouched(_ sender: PassableUIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    ///  selection for drp down
    @objc func textFieldDidChange(_ textField: UITextField) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: listArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.choiceName?.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            textField.text = selectedItem?.choiceName
        }
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: textField, size: CGSize(width: textField.frame.width, height: (Double(listArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    ///  multiple selection with selction false
    @objc func buttonAction(_ sender: PassableUIButton!){
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
    }
    
    ///  created Lead on existing datanaviagte to lead list
    func LeadDataRecived() {
        view.HideSpinner()
        do {
            sleep(8)
        }
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("NotificationLeadList"), object: nil)
    }
    
    func errorReceived(error: String) {
        view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    /// submit button which validate all  condition
//    @IBAction func submitButtonClicked() {
//        k = 0
//        j = 0
//        for index in 0..<(patientQuestionList.count) {
//            let cellIndexPath = IndexPath(item: index, section: 0)
//            let item = patientQuestionList[cellIndexPath.row]
//            /// InputType
//            if let InputTypeCell = createLeadTableView.cellForRow(at: cellIndexPath) as? InputTypeTableViewCell {
//                print(InputTypeCell.inputeTypeLbi.text ?? String.blank)
//                
//                guard let txtField = InputTypeCell.inputeTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
//                    InputTypeCell.inputeTypeTextField.showError(message: item.validationMessage)
//                    return
//                }
//                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: InputTypeCell.inputeTypeTextField.text ?? String.blank)
//            }
//            /// textType
//            if let textTypeCell = createLeadTableView.cellForRow(at: cellIndexPath) as? TextTypeTableViewCell {
//                print(textTypeCell.textTypeLbi.text ?? String.blank)
//                guard let txtField = textTypeCell.textTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
//                    textTypeCell.errorTypeLbi.isHidden = false
//                    textTypeCell.errorTypeLbi.text =  item.validationMessage
//                    return
//                }
//                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: textTypeCell.textTypeTextField.text ?? String.blank)
//            }
//            
//            /// yesNoType
//            if let yesNoTypeCell = createLeadTableView.cellForRow(at: cellIndexPath) as? YesNoTypeTableViewCell {
//                print(yesNoTypeCell.yesNoTypeLbi.text ?? String.blank)
//                print(yesNoTypeCell.yesTypeButton.isSelected)
//                print(yesNoTypeCell.NoTypeButton.isSelected)
//                self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: yesNoTypeCell.yesTypeButton.isSelected )
//            }
//            
//            /// MultipleSelectionType
//            if let MultipleSelectionCell = createLeadTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionTextTypeTableViewCell {
//                print(MultipleSelectionCell.inputeTypeLbi.text ?? String.blank)
//                var selectedStringArray = [String]()
//                var patientQuestionChoicesList: [Any] = []
//                var index = 0
//                for view in MultipleSelectionCell.contentView.subviews {
//                    print(view.tag)
//                    if let inputTypeTxtField = view.viewWithTag(k) as? PassableUIButton {
//                        print(inputTypeTxtField.isSelected)
//                        print(inputTypeTxtField.titleLabel?.text ?? String.blank)
//                        
//                        if inputTypeTxtField.isSelected {
//                            selectedStringArray.append(inputTypeTxtField.titleLabel?.text ?? String.blank)
//                        }
//                        
//                        if let itemList = item.patientQuestionChoices?[index] {
//                            let list = self.patientQuestionChoicesList(patientQuestionChoices: itemList, selected: inputTypeTxtField.isSelected)
//                            patientQuestionChoicesList.append(list)
//                        }
//                        k += 1
//                        index += 1
//                    }
//                }
//                let selectedStr = selectedStringArray.joined(separator: ",")
//                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: selectedStr)
//            }
//            
//            /// DropDownType
//            if let dropDownTypeCell = createLeadTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionWithDropDownTypeTableViewCell {
//                print(dropDownTypeCell.dropDownTypeLbi.text ?? String.blank)
//                
//                guard let txtField = dropDownTypeCell.dropDownTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
//                    dropDownTypeCell.dropDownTypeTextField.showError(message: item.validationMessage)
//                    return
//                }
//                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dropDownTypeCell.dropDownTypeTextField.text ?? String.blank)
//            }
//            
//            /// preSelectCheckboxType
//            if let preSelectCheckboxCell = createLeadTableView.cellForRow(at: cellIndexPath) as? PreSelectCheckboxTableViewCell {
//                print(preSelectCheckboxCell.preSelectCheckbox.text ?? String.blank)
//                print(preSelectCheckboxCell.preSelectedCheckBoxButton.isSelected)
//                
//                self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: preSelectCheckboxCell.preSelectedCheckBoxButton.isSelected)
//            }
//            
//            /// multipleSelectionFalseType
//            if let multipleSelectionTextWithFalseCell = createLeadTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionTextWithFalseTableViewCell {
//                var selectedString: String = ""
//                print(multipleSelectionTextWithFalseCell.multipleSelectionTypeLbi.text ?? String.blank)
//                print(multipleSelectionTextWithFalseCell.isSelected)
//                var j = 0
//                for view in multipleSelectionTextWithFalseCell.contentView.subviews {
//                    print(view.tag)
//                    if let buttonField = view.viewWithTag(j) as? PassableUIButton {
//                        print(buttonField.isSelected)
//                        if buttonField.isSelected {
//                            selectedString = buttonField.titleLabel?.text ?? String.blank
//                        }
//                        print(buttonField.titleLabel?.text ?? String.blank)
//                        j += 1
//                    }
//                    self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: selectedString)
//                }
//            }
//            
//            /// DateType
//            if let dateTypeCell = createLeadTableView.cellForRow(at: cellIndexPath) as? DateTypeTableViewCell {
//                print(dateTypeCell.dateTypeLbi.text ?? String.blank)
//                print(dateTypeCell.dateTypeTextField.text ?? String.blank)
//                
//                guard let txtField = dateTypeCell.dateTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
//                    dateTypeCell.dateTypeTextField.showError(message: item.validationMessage)
//                    return
//                }
//                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dateTypeCell.dateTypeTextField.text ?? String.blank)
//            }
//        }
//        
//        let patientQuestionAnswers: [String: Any] = [
//            "id": 1234,
//            "questionnaireId": 7996,
//            "source": "Manual",
//            "patientQuestionAnswers": patientQuestionAnswers
//        ]
//        print(patientQuestionAnswers)
//        view.ShowSpinner()
//        viewModel?.createLead(patientQuestionAnswers: patientQuestionAnswers)
//        print("all condtion meet")
//        
//    }
    
    func patientQuestionChoicesList(patientQuestionChoices : PatientQuestionChoices, selected : Bool) -> [String : Any] {
        let patientQuestionChoices: [String : Any] = [
            "choiceName": patientQuestionChoices.choiceName ?? 0,
            "choiceId": patientQuestionChoices.choiceId ?? 0,
            "selected": selected
        ]
        return patientQuestionChoices
    }
    
    func setPatientQuestionChoicesList(patientQuestionAnswersList : PatientQuestionAnswersList, patientQuestionList: [Any], selectedString:[String] = []){
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? String.blank,
            "questionType": patientQuestionAnswersList.questionType ?? String.blank,
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": patientQuestionAnswersList.answerText ?? String.blank,
            "answerComments": "",
            "patientQuestionChoices": patientQuestionList,
            "required": patientQuestionAnswersList.required ?? String.blank,
            "hidden": patientQuestionAnswersList.hidden ?? false,
            "showDropDown": patientQuestionAnswersList.showDropDown ?? false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
    
    /// for all
    func setPatientQuestionList(patientQuestionAnswersList : PatientQuestionAnswersList, answerText: String) {
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? String.blank,
            "questionType": patientQuestionAnswersList.questionType ?? String.blank,
            "allowMultipleSelection": patientQuestionAnswersList.allowMultipleSelection ?? String.blank,
            "preSelectCheckbox": patientQuestionAnswersList.preSelectCheckbox ?? String.blank,
            "answer": patientQuestionAnswersList.answer ?? String.blank,
            "answerText": answerText,
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": patientQuestionAnswersList.required ?? String.blank,
            "hidden": patientQuestionAnswersList.hidden ?? false,
            "showDropDown": patientQuestionAnswersList.showDropDown ?? false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
    
    func setPatientQuestionListForBool(patientQuestionAnswersList : PatientQuestionAnswersList, answerText: Bool){
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? String.blank,
            "questionType": patientQuestionAnswersList.questionType ?? String.blank,
            "allowMultipleSelection": patientQuestionAnswersList.allowMultipleSelection ?? String.blank,
            "preSelectCheckbox": patientQuestionAnswersList.preSelectCheckbox ?? String.blank,
            "answer": answerText,
            "answerText": answerText,
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": patientQuestionAnswersList.required ?? String.blank,
            "hidden": patientQuestionAnswersList.hidden ?? false,
            "showDropDown": patientQuestionAnswersList.showDropDown ?? false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
}

extension CreateLeadViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customViewHight.constant = tableViewHeight + 180
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customViewHight.constant = tableViewHeight + 180
    }
}
