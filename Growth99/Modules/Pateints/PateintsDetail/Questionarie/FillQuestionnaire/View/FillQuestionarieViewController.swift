//
//  FillQuestionarieViewController.swift
//  Growth99
//
//  Created by nitin auti on 22/01/23.
//

import Foundation
import UIKit

protocol FillQuestionarieViewControllerProtocol: AnyObject {
    func questionareAdddedSuccessfully()
    func questionnaireListRecived()
    func errorReceived(error: String)
}

class FillQuestionarieViewController: UIViewController, FillQuestionarieViewControllerProtocol,MultipleSelectionWithDropDownTypeTableViewCellDelegate {
    
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!
    @IBOutlet weak var customView : UIView!
    @IBOutlet weak var questionarieTableView : UITableView!
    @IBOutlet weak var customViewHight : NSLayoutConstraint!

    var viewModel: FillQuestionarieViewModelProtocol?
    private var patientQuestionAnswers = Array<Any>()
    var tableview : UITableView?

    var questionnaireId = Int()
    var pateintId = Int()
  
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
        viewModel?.getQuestionnaireData(pateintId: pateintId , questionnaireId: questionnaireId)
        setUpUI()
        self.registerTableViewCell()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let userInfo = [ "selectedIndex" : 1 ]
            NotificationCenter.default.post(name: Notification.Name("changeSegment"), object: nil,userInfo: userInfo)
        }
    }
    
    private func setUpUI(){
        submitButton.roundCorners(corners: [.allCorners], radius: 10)
        CancelButton.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    func registerTableViewCell(){
        questionarieTableView.register(UINib(nibName: "InputTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "TextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "YesNoTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "YesNoTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "DateTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTypeTableViewCell")

        questionarieTableView.register(UINib(nibName: "MultipleSelectionTextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "MultipleSelectionWithDropDownTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "MultipleSelectionTextWithFalseTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextWithFalseTableViewCell")
        
        questionarieTableView.register(UINib(nibName: "PreSelectCheckboxTableViewCell", bundle: nil), forCellReuseIdentifier: "PreSelectCheckboxTableViewCell")
    }
    
    /// recvied QuestionnaireList
    func questionnaireListRecived() {
        view.HideSpinner()
        self.questionarieTableView.reloadData()
        customViewHight.constant = tableViewHeight + 300
    }
  
    ///  selection for drp down
    func showDropDownQuestionchoice(cell: MultipleSelectionWithDropDownTypeTableViewCell, index: IndexPath){
        let questionarieVM = viewModel?.getQuestionnaireListAtIndex(index: index.row)
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

    ///  created Lead on existing datanaviagte to lead list
    func questionareAdddedSuccessfully() {
        view.HideSpinner()
        do {
            sleep(8)
        }
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("NotificationQuestionarieList"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// submit button which validate all  condition
    @IBAction func submitButtonClicked() {
        let patientQuestionList = viewModel?.getQuestionnaireData ?? []
        
        for index in 0..<(patientQuestionList.count ) {
            let cellIndexPath = IndexPath(item: index, section: 0)
            let item = patientQuestionList[cellIndexPath.row]
            
            ///  /// 1. questionnaireType ->  InputType
            if let InputTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? InputTypeTableViewCell {
                print(InputTypeCell.questionnaireName.text ?? String.blank)

                guard let txtField = InputTypeCell.inputeTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    InputTypeCell.inputeTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: InputTypeCell.inputeTypeTextField.text ?? String.blank)
            }
            
            /// 2. questionnaireType -> TextType
            if let textTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? TextTypeTableViewCell {
                print(textTypeCell.questionnaireName.text ?? String.blank)
               
                guard let txtField = textTypeCell.textTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    textTypeCell.errorTypeLbi.isHidden = false
                    textTypeCell.errorTypeLbi.text =  item.validationMessage
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: textTypeCell.textTypeTextField.text ?? String.blank)
            }
            
            /// 3. questionnaireType  -> DateType
            if let dateTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? DateTypeTableViewCell {
                print(dateTypeCell.questionnaireName.text ?? String.blank)
                print(dateTypeCell.dateTypeTextField.text ?? String.blank)

                guard let txtField = dateTypeCell.dateTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    dateTypeCell.dateTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dateTypeCell.dateTypeTextField.text ?? String.blank)
            }

           // 4.questionnaireTyp-> yesNoType
            if let yesNoTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? YesNoTypeTableViewCell {
                print(yesNoTypeCell.questionnaireName.text ?? String.blank)

                self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: yesNoTypeCell.yesTypeButton.isSelected )
            }

            /// 5. questionnaireType  MultipleSelectionType && DropDownType
            if let dropDownTypeCell = questionarieTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionWithDropDownTypeTableViewCell {
                print(dropDownTypeCell.questionnaireName.text ?? String.blank)

                guard let txtField = dropDownTypeCell.dropDownTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    dropDownTypeCell.dropDownTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dropDownTypeCell.dropDownTypeTextField.text ?? String.blank)
            }
            
            ///6 . questionnaireType  Multiple_Selection_Text
            if let MultipleSelectionCell = questionarieTableView.cellForRow(at: cellIndexPath) as? MultipleSelectionTextTypeTableViewCell {
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
            "id": viewModel?.getQuestionnaireDetailInfo?.id ?? 0,
            "questionnaireId": viewModel?.getQuestionnaireDetailInfo?.questionnaireId ?? 0,
            "patientId": viewModel?.getQuestionnaireDetailInfo?.patientId ?? 0,
            "source": "Manual",
            "patientQuestionAnswers": patientQuestionAnswers
        ]
        print(patientQuestionAnswers)
        view.ShowSpinner()
        viewModel?.createQuestionnaireForPateint(patientQuestionAnswers: patientQuestionAnswers)
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

extension FillQuestionarieViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customViewHight.constant = tableViewHeight + 300
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customViewHight.constant = tableViewHeight + 300
    }
}
