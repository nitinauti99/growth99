//
//  FillQuestionarieViewController.swift
//  Growth99
//
//  Created by nitin auti on 22/01/23.
//

import Foundation
import UIKit

protocol FillQuestionarieViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func QuestionnaireListRecived()
    func errorReceived(error: String)
}

class FillQuestionarieViewController: UIViewController, FillQuestionarieViewControllerProtocol {
    
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!
    @IBOutlet weak var customView : UIView!
   
    @IBOutlet weak var questionarieTableView : UITableView!
    @IBOutlet weak var customViewHight : NSLayoutConstraint!
    
    private var viewModel: FillQuestionarieViewModelProtocol?
    private var patientQuestionAnswers = Array<Any>()
    var buttons = [UIButton]()
    var patientQuestionList = [PatientQuestionAnswersList]()
    var listArray = [PatientQuestionChoices]()
    var k = 0
    var j = 0
    var questionnaireId = Int()
    
    private lazy var inputTypeTextField: CustomTextField = {
        let textField = CustomTextField()
        return textField
    }()
    
    private var tableViewHeight: CGFloat {
        questionarieTableView.layoutIfNeeded()
        return questionarieTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = FillQuestionarieViewModel(delegate: self)
        self.view.ShowSpinner()
        viewModel?.getQuestionnaireId(pateintId: 46782 , questionnaireId: questionnaireId)
        setUpUI()
        self.registerTableViewCell()
    }
    
    
    private func setUpUI(){
        submitButton.roundCorners(corners: [.allCorners], radius: 10)
        CancelButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    func registerTableViewCell(){
        questionarieTableView.register(UINib(nibName: "InputTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "TextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "YesNoTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "YesNoTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "MultipleSelectionTextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "DateTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "MultipleSelectionWithDropDownTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "MultipleSelectionTextWithFalseTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextWithFalseTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "PreSelectCheckboxTableViewCell", bundle: nil), forCellReuseIdentifier: "PreSelectCheckboxTableViewCell")
    }
    
    /// recvied QuestionnaireList
    func QuestionnaireListRecived() {
        view.HideSpinner()
        patientQuestionList = viewModel?.leadUserQuestionnaireList ?? []
        self.questionarieTableView.reloadData()
        customViewHight.constant = tableViewHeight + 300
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
        self.view.showToast(message: error)
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    /// submit button which validate all  condition
    @IBAction func submitButtonClicked() {
        k = 0
        j = 0
        for index in 0..<(patientQuestionList.count) {
            let cellIndexPath = IndexPath(item: index, section: 0)
            let item = patientQuestionList[cellIndexPath.row]
            /// InputType
            if let InputTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? InputTypeTableViewCell {
                print(InputTypeCell.inputeTypeLbi.text ?? "")
                
                guard let txtField = InputTypeCell.inputeTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? "") , isValid else {
                    InputTypeCell.inputeTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: InputTypeCell.inputeTypeTextField.text ?? "")
            }
            /// textType
            if let textTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? TextTypeTableViewCell {
                print(textTypeCell.textTypeLbi.text ?? "")
                guard let txtField = textTypeCell.textTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? "") , isValid else {
                    textTypeCell.errorTypeLbi.isHidden = false
                    textTypeCell.errorTypeLbi.text =  item.validationMessage
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: textTypeCell.textTypeTextField.text ?? "")
            }
            
            /// yesNoType
            if let yesNoTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? YesNoTypeTableViewCell {
                print(yesNoTypeCell.yesNoTypeLbi.text ?? "")
                print(yesNoTypeCell.yesTypeButton.isSelected)
                print(yesNoTypeCell.NoTypeButton.isSelected)
                self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: yesNoTypeCell.yesTypeButton.isSelected )
            }
            
            /// MultipleSelectionType
            if let MultipleSelectionCell = questionarieTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionTextTypeTableViewCell {
                print(MultipleSelectionCell.inputeTypeLbi.text ?? "")
                var selectedStringArray = [String]()
                var patientQuestionChoicesList: [Any] = []
                var index = 0
                for view in MultipleSelectionCell.contentView.subviews {
                    print(view.tag)
                    if let inputTypeTxtField = view.viewWithTag(k) as? PassableUIButton {
                        print(inputTypeTxtField.isSelected)
                        print(inputTypeTxtField.titleLabel?.text ?? "")
                        
                        if inputTypeTxtField.isSelected {
                            selectedStringArray.append(inputTypeTxtField.titleLabel?.text ?? "")
                        }
                        
                        if let itemList = item.patientQuestionChoices?[index] {
                            let list = self.patientQuestionChoicesList(patientQuestionChoices: itemList, selected: inputTypeTxtField.isSelected)
                            patientQuestionChoicesList.append(list)
                        }
                        k += 1
                        index += 1
                    }
                }
                let selectedStr = selectedStringArray.joined(separator: ",")
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: selectedStr)
            }
            
            /// DropDownType
            if let dropDownTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionWithDropDownTypeTableViewCell {
                print(dropDownTypeCell.dropDownTypeLbi.text ?? "")
                
                guard let txtField = dropDownTypeCell.dropDownTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? "") , isValid else {
                    dropDownTypeCell.dropDownTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dropDownTypeCell.dropDownTypeTextField.text ?? "")
            }
            
            /// preSelectCheckboxType
            if let preSelectCheckboxCell = questionarieTableView.cellForRow(at: cellIndexPath) as? PreSelectCheckboxTableViewCell {
                print(preSelectCheckboxCell.preSelectCheckbox.text ?? "")
                print(preSelectCheckboxCell.preSelectedCheckBoxButton.isSelected)
                
                self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: preSelectCheckboxCell.preSelectedCheckBoxButton.isSelected)
            }
            
            /// multipleSelectionFalseType
            if let multipleSelectionTextWithFalseCell = questionarieTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionTextWithFalseTableViewCell {
                var selectedString: String = ""
                print(multipleSelectionTextWithFalseCell.multipleSelectionTypeLbi.text ?? "")
                print(multipleSelectionTextWithFalseCell.isSelected)
                var j = 0
                for view in multipleSelectionTextWithFalseCell.contentView.subviews {
                    print(view.tag)
                    if let buttonField = view.viewWithTag(j) as? PassableUIButton {
                        print(buttonField.isSelected)
                        if buttonField.isSelected {
                            selectedString = buttonField.titleLabel?.text ?? ""
                        }
                        print(buttonField.titleLabel?.text ?? "")
                        j += 1
                    }
                    self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: selectedString)
                }
            }
            
            /// DateType
            if let dateTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? DateTypeTableViewCell {
                print(dateTypeCell.dateTypeLbi.text ?? "")
                print(dateTypeCell.dateTypeTextField.text ?? "")
                
                guard let txtField = dateTypeCell.dateTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? "") , isValid else {
                    dateTypeCell.dateTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dateTypeCell.dateTypeTextField.text ?? "")
            }
        }
        
        let patientQuestionAnswers: [String: Any] = [
            "id": 1234,
            "questionnaireId": 7996,
            "source": "Manual",
            "patientQuestionAnswers": patientQuestionAnswers
        ]
        print(patientQuestionAnswers)
        view.ShowSpinner()
        viewModel?.createLead(patientQuestionAnswers: patientQuestionAnswers)
        print("all condtion meet")
        
    }
    
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
            "questionName": patientQuestionAnswersList.questionName ?? "",
            "questionType": patientQuestionAnswersList.questionType ?? "",
            "allowMultipleSelection": false,
            "preSelectCheckbox": false,
            "answer": "",
            "answerText": patientQuestionAnswersList.answerText ?? "",
            "answerComments": "",
            "patientQuestionChoices": patientQuestionList,
            "required": patientQuestionAnswersList.required ?? "",
            "hidden": patientQuestionAnswersList.hidden ?? false,
            "showDropDown": patientQuestionAnswersList.showDropDown ?? false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
    
    /// for all
    func setPatientQuestionList(patientQuestionAnswersList : PatientQuestionAnswersList, answerText: String) {
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? "",
            "questionType": patientQuestionAnswersList.questionType ?? "",
            "allowMultipleSelection": patientQuestionAnswersList.allowMultipleSelection ?? "",
            "preSelectCheckbox": patientQuestionAnswersList.preSelectCheckbox ?? "",
            "answer": patientQuestionAnswersList.answer ?? "",
            "answerText": answerText,
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": patientQuestionAnswersList.required ?? "",
            "hidden": patientQuestionAnswersList.hidden ?? false,
            "showDropDown": patientQuestionAnswersList.showDropDown ?? false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
    
    func setPatientQuestionListForBool(patientQuestionAnswersList : PatientQuestionAnswersList, answerText: Bool){
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? "",
            "questionType": patientQuestionAnswersList.questionType ?? "",
            "allowMultipleSelection": patientQuestionAnswersList.allowMultipleSelection ?? "",
            "preSelectCheckbox": patientQuestionAnswersList.preSelectCheckbox ?? "",
            "answer": answerText,
            "answerText": answerText,
            "answerComments": "",
            "patientQuestionChoices": [],
            "required": patientQuestionAnswersList.required ?? "",
            "hidden": patientQuestionAnswersList.hidden ?? false,
            "showDropDown": patientQuestionAnswersList.showDropDown ?? false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
}

extension FillQuestionarieViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customViewHight.constant = tableViewHeight + 300
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customViewHight.constant = tableViewHeight + 300
    }
}
