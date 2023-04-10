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

class CreateLeadViewController: UIViewController{

    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!
    @IBOutlet weak var customView : UIView!
    @IBOutlet weak var tableView : UITableView!
    
    var viewModel: CreateLeadViewModelProtocol?
    private var patientQuestionAnswers = Array<Any>()

    private var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadViewModel(delegate: self)
        self.registerTableViewCell()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Create Lead"
        self.view.ShowSpinner()
        self.viewModel?.getQuestionnaireId()
    }
    
    private func setUpUI(){
        self.submitButton.roundCorners(corners: [.allCorners], radius: 10)
        self.CancelButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    func registerTableViewCell(){
        tableView.register(UINib(nibName: "LeadInputTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadInputTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadTextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadTextTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadYesNoTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadYesNoTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadDateTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadDateTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadMultipleSelectionTextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadMultipleSelectionTextTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadMultipleSelectionWithDropDownTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadMultipleSelectionTextWithFalseTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextWithFalseTableViewCell")
    }
        
    @IBAction func closeButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// submit button which validate all  condition
    @IBAction func submitButtonClicked() {
        let patientQuestionList = viewModel?.getLeadUserQuestionnaireList ?? []

        for index in 0..<(patientQuestionList.count ) {
            let cellIndexPath = IndexPath(item: index, section: 0)
            let item = patientQuestionList[cellIndexPath.row]
            
            ///  /// 1. questionnaireType ->  InputType
            if let InputTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadInputTypeTableViewCell {
                print(InputTypeCell.questionnaireName.text ?? String.blank)

                guard let txtField = InputTypeCell.inputeTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    InputTypeCell.inputeTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: InputTypeCell.inputeTypeTextField.text ?? String.blank)
            }
            
            /// 2. questionnaireType -> TextType
            if let textTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadTextTypeTableViewCell {
                print(textTypeCell.questionnaireName.text ?? String.blank)
               
                guard let txtField = textTypeCell.textTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    textTypeCell.errorTypeLbi.isHidden = false
                    textTypeCell.errorTypeLbi.text =  item.validationMessage
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: textTypeCell.textTypeTextField.text ?? String.blank)
            }
            
            /// 3. questionnaireType  -> DateType
            if let dateTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadDateTypeTableViewCell {
                print(dateTypeCell.questionnaireName.text ?? String.blank)
                print(dateTypeCell.dateTypeTextField.text ?? String.blank)

                guard let txtField = dateTypeCell.dateTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    dateTypeCell.dateTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dateTypeCell.dateTypeTextField.text ?? String.blank)
            }

           // 4.questionnaireTyp-> yesNoType
            if let yesNoTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadYesNoTypeTableViewCell {
                print(yesNoTypeCell.questionnaireName.text ?? String.blank)

                self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: yesNoTypeCell.yesTypeButton.isSelected )
            }

            /// 5. questionnaireType  MultipleSelectionType && DropDownType
            if let dropDownTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadMultipleSelectionWithDropDownTypeTableViewCell {
                print(dropDownTypeCell.questionnaireName.text ?? String.blank)

                guard let txtField = dropDownTypeCell.dropDownTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    dropDownTypeCell.dropDownTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dropDownTypeCell.dropDownTypeTextField.text ?? String.blank)
            }
            
            ///6 . questionnaireType  Multiple_Selection_Text
            if let MultipleSelectionCell = tableView.cellForRow(at: cellIndexPath) as? LeadMultipleSelectionTextTypeTableViewCell {
                print(MultipleSelectionCell.questionnaireName.text ?? String.blank)

                let patientQuestionChoicesList = item.patientQuestionChoices ?? []
                var selectedStringArray = [String]()
                var patientQuestionChoices: PatientQuestionChoices!
                var patientQuestionChoicesItem: [Any] = []

                let tableView = MultipleSelectionCell.getTableView()
                
                for childIndex in 0..<( patientQuestionChoicesList.count) {
                    let cellchildIndexPath = IndexPath(item: childIndex, section: 0)
                    patientQuestionChoices = patientQuestionChoicesList[cellchildIndexPath.row]
                  
                    /// retrived data for child cell
                    if let MultipleSelectionQuestionChoice = MultipleSelectionCell.tableView(tableView, cellForRowAt: cellchildIndexPath) as? MultipleSelectionQuestionChoiceTableViewCell {
                        print("receved child table view")
                        selectedStringArray.append(MultipleSelectionQuestionChoice.questionnaireChoiceName.text ?? String.blank)
                       
                        let list = self.patientQuestionChoicesList(patientQuestionChoices: patientQuestionChoices, selected: MultipleSelectionQuestionChoice.questionnaireChoiceButton.isSelected)
                       
                        patientQuestionChoicesItem.append(list)
                    }
                }
                let selectedStr = selectedStringArray.joined(separator: ",")
                self.setPatientQuestionChoicesList(patientQuestionAnswersList: item, patientQuestionList: patientQuestionChoicesItem, selectedString: selectedStr )
            }
        }

        let patientQuestionAnswers: [String: Any] = [
            "id": viewModel?.getQuestionnaireListInfo?.id ?? 0,
            "questionnaireId": viewModel?.getQuestionnaireListInfo?.questionnaireId ?? 0,
            "source": "Manual",
            "patientQuestionAnswers": patientQuestionAnswers
        ]
        print(patientQuestionAnswers)
        view.ShowSpinner()
        viewModel?.createLead(patientQuestionAnswers: patientQuestionAnswers)
        print("all condtion meet")
    }
    
  
    /// setDataFor InputType Question
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
    
    /// Set Dat For InputTaype answerText as Bool
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
    
    //// add patientQuestionChoices inside array
    func patientQuestionChoicesList(patientQuestionChoices : PatientQuestionChoices, selected : Bool) -> [String : Any] {
        let patientQuestionChoices: [String : Any] = [
            "choiceName": patientQuestionChoices.choiceName ?? 0,
            "choiceId": patientQuestionChoices.choiceId ?? 0,
            "selected": selected
        ]
        return patientQuestionChoices
    }

    func setPatientQuestionChoicesList(patientQuestionAnswersList : PatientQuestionAnswersList, patientQuestionList: [Any], selectedString: String){
        let patientQuestion: [String : Any] = [
            "questionId": patientQuestionAnswersList.questionId ?? 0,
            "questionName": patientQuestionAnswersList.questionName ?? String.blank,
            "questionType": patientQuestionAnswersList.questionType ?? String.blank,
            "allowMultipleSelection": patientQuestionAnswersList.allowMultipleSelection ?? String.blank,
            "preSelectCheckbox": patientQuestionAnswersList.preSelectCheckbox ?? String.blank,
            "answer": false,
            "answerText": patientQuestionAnswersList.answerText ?? String.blank,
            "answerComments": "",
            "patientQuestionChoices": patientQuestionList,
            "required": patientQuestionAnswersList.required ?? String.blank,
            "hidden": patientQuestionAnswersList.hidden ?? false,
            "showDropDown": patientQuestionAnswersList.showDropDown ?? false
        ]
        patientQuestionAnswers.append(patientQuestion)
    }
}

extension CreateLeadViewController: CreateLeadViewControllerProtocol {
    /// api Call
    func QuestionnaireIdRecived() {
        viewModel?.getQuestionnaireList()
    }
    
    /// recvied QuestionnaireList
    func QuestionnaireListRecived() {
        view.HideSpinner()
        self.tableView.reloadData()
        //customViewHight.constant = tableViewHeight + 320
    }

    
    ///  created Lead on existing datanaviagte to lead list
    func LeadDataRecived() {
        view.HideSpinner()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popViewController(animated: true)
        })
        NotificationCenter.default.post(name: Notification.Name("NotificationLeadList"), object: nil)
    }
    
    func errorReceived(error: String) {
        view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}

extension CreateLeadViewController: LeadMultipleSelectionWithDropDownTypeTableViewCellDelegate {
    // show drop down list
    func showDropDownQuestionchoice(cell: LeadMultipleSelectionWithDropDownTypeTableViewCell, index: IndexPath) {
        let questionarieVM = viewModel?.getLeadQuestionnaireListAtIndex(index: index.row)
        let patientQuestionChoices = questionarieVM?.patientQuestionChoices ?? []

        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: patientQuestionChoices, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.choiceName?.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            cell.dropDownTypeTextField.text = selectedItem?.choiceName
        }
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: cell.dropDownButton, size: CGSize(width: cell.dropDownButton.frame.width, height: (Double(patientQuestionChoices.count * 44))), arrowDirection: .up), from: self)
    }
    
}
