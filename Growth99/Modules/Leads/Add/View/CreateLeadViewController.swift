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
    @IBOutlet weak var tableViewHight : NSLayoutConstraint!
    var imageUrl: String = ""
    
    var viewModel: CreateLeadViewModelProtocol?
    private var patientQuestionAnswers = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLeadViewModel(delegate: self)
        self.registerTableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Create Lead"
        self.view.ShowSpinner()
        self.viewModel?.getQuestionnaireId()
    }
    
    func scrollViewHeight() -> CGFloat  {
        var tableViewHight = CGFloat()
        let patientQuestionList = viewModel?.getLeadUserQuestionnaireList ?? []

        for item in patientQuestionList {
            if item.questionType  == "Input" || item.questionType == "Yes_No" || item.questionType == "Date" {
                tableViewHight += 110
            }else if (item.questionType  == "Text") {
                tableViewHight += 200
            }else if (item.questionType  == "Multiple_Selection_Text") {
                if item.showDropDown == true {
                    tableViewHight += 100
                }else {
                    tableViewHight += CGFloat((item.patientQuestionChoices?.count ?? 0) * 100)
                }
            }
        }
        return tableViewHight
    }
    
    func registerTableViewCell(){
        tableView.register(UINib(nibName: "LeadInputTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadInputTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadTextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadTextTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadYesNoTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadYesNoTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadDateTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadDateTypeTableViewCell")
        
        tableView.register(UINib(nibName: "FileTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "FileTypeTableViewCell")
        
        tableView.register(UINib(nibName: "BottomTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BottomTableViewCell")

        tableView.register(UINib(nibName: "LeadMultipleSelectionTextTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadMultipleSelectionTextTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadMultipleSelectionWithDropDownTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadMultipleSelectionWithDropDownTypeTableViewCell")
        
        tableView.register(UINib(nibName: "LeadMultipleSelectionTextWithFalseTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleSelectionTextWithFalseTableViewCell")
    }
    
}

extension CreateLeadViewController: BottomTableViewCellProtocol {
   
    func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// submit button which validate all  condition
    func submitButtonPressed() {
        let patientQuestionList = viewModel?.getLeadUserQuestionnaireList ?? []
        
        for index in 0..<(patientQuestionList.count) {
            let cellIndexPath  = IndexPath(row: index, section: 0)
            let item = patientQuestionList[cellIndexPath.row]
            
            switch (item.questionType, item.showDropDown){
            case ("Input", false):
                guard let inputTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadInputTypeTableViewCell else { return  }
                guard let txtField = inputTypeCell.inputeTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    inputTypeCell.inputeTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: inputTypeCell.inputeTypeTextField.text ?? String.blank)
                
            case ("Text", false):
                guard let textTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadTextTypeTableViewCell else { return }
                guard let txtField = textTypeCell.textTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    textTypeCell.errorTypeLbi.isHidden = false
                    textTypeCell.errorTypeLbi.text =  item.validationMessage
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: textTypeCell.textTypeTextField.text ?? String.blank)
                
            case ("Yes_No", false):
                guard let yesNoTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadYesNoTypeTableViewCell else { return }
                
                self.setPatientQuestionListForBool(patientQuestionAnswersList: item, answerText: yesNoTypeCell.yesTypeButton.isSelected )
                
            case ("Date", false):
                guard let dateTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadDateTypeTableViewCell else { return }
                guard let txtField = dateTypeCell.dateTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    dateTypeCell.dateTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dateTypeCell.dateTypeTextField.text ?? String.blank)
                
            case ("File", false):
                 guard let fileCell = tableView.dequeueReusableCell(withIdentifier: "FileTypeTableViewCell", for: cellIndexPath) as? FileTypeTableViewCell else { return }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: imageUrl)

            case ("Multiple_Selection_Text", false):
                guard let multipleSelectionCell = tableView.cellForRow(at: cellIndexPath) as? LeadMultipleSelectionTextTypeTableViewCell else { return  }
                let leadQuestionChoicesList = item.patientQuestionChoices ?? []
                var selectedStringArray = [String]()
                var leadQuestionChoices: PatientQuestionChoices!
                var leadQuestionChoicesItem: [Any] = []
                let tableView = multipleSelectionCell.getTableView()
                
                for childIndex in 0..<(leadQuestionChoicesList.count) {
                    let cellchildIndexPath = IndexPath(row: childIndex, section: 0)
                    leadQuestionChoices = leadQuestionChoicesList[cellchildIndexPath.row]
                    
                    /// retrived data for child cell
                    if let multipleSelectionQuestionChoice = tableView.cellForRow(at: cellchildIndexPath) as? LeadMultipleSelectionQuestionChoiceTableViewCell {
                        print("receved child table view")
                        
                        if multipleSelectionQuestionChoice.questionnaireChoiceButton.isSelected == true {
                            selectedStringArray.append(multipleSelectionQuestionChoice.questionnaireChoiceName.text ?? String.blank)
                        }
                        
                        let list = self.patientQuestionChoicesList(patientQuestionChoices: leadQuestionChoices, selected: multipleSelectionQuestionChoice.questionnaireChoiceButton.isSelected)
                        
                        leadQuestionChoicesItem.append(list)
                    }
                }
                let selectedStr = selectedStringArray.joined(separator: ",")
                self.setPatientQuestionChoicesList(patientQuestionAnswersList: item, patientQuestionList: leadQuestionChoicesItem, selectedString: selectedStr)
                
            case ("Multiple_Selection_Text", true):
                guard let dropDownTypeCell = tableView.cellForRow(at: cellIndexPath) as? LeadMultipleSelectionWithDropDownTypeTableViewCell else { return  }
               
                guard let txtField = dropDownTypeCell.dropDownTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(txtField, regex: item.regex ?? String.blank) , isValid else {
                    dropDownTypeCell.dropDownTypeTextField.showError(message: item.validationMessage)
                    return
                }
                self.setPatientQuestionList(patientQuestionAnswersList: item, answerText: dropDownTypeCell.dropDownTypeTextField.text ?? String.blank)
                
            default:
                break
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
            "answer": NSNull(),
            "answerText": answerText,
            "answerComments": NSNull(),
            "patientQuestionChoices": [],
            "fileSource": NSNull(),
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
            "answerText": selectedString,
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
        self.tableViewHight.constant = self.scrollViewHeight() + 100
    }

    ///  created Lead on existing datanaviagte to lead list
    func LeadDataRecived() {
        view.HideSpinner()
        self.view.showToast(message: "Data submitted successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
        NotificationCenter.default.post(name: Notification.Name("NotificationLeadList"), object: nil)
    }
    
    func errorReceived(error: String) {
        view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension CreateLeadViewController: LeadMultipleSelectionWithDropDownTypeTableViewCellDelegate {
    // show drop down list
    func showDropDownQuestionchoice(cell: LeadMultipleSelectionWithDropDownTypeTableViewCell, index: IndexPath) {
        let questionarieVM = viewModel?.getLeadQuestionnaireListAtIndex(index: index.row)
        let patientQuestionChoices = questionarieVM?.patientQuestionChoices ?? []

        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: patientQuestionChoices, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.choiceName
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            cell.dropDownTypeTextField.text = selectedItem?.choiceName
        }
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: cell.dropDownButton, size: CGSize(width: cell.dropDownButton.frame.width, height: (Double(patientQuestionChoices.count * 44))), arrowDirection: .up), from: self)
    }
}

extension CreateLeadViewController: FileTypeTableViewCellProtocol {
    
    func presentImagePickerController(pickerController: UIImagePickerController) {
        present(pickerController, animated: true, completion: nil)
    }
    
    func dissmissImagePickerController(id: Int, questionId: Int, image: UIImage) {
        self.dismiss(animated: true, completion: nil)
        self.view.ShowSpinner()
        var url = String()
        url = ApiUrl.formSubmission.appending("\(id)/question/\(questionId)/uploadfile")
        
        let urlParameter: Parameters = [:]
        
        let request = ImageUplodManager(uploadImage: image, parameters: urlParameter, url: URL(string: url)!, method: "POST", name: "file", fileName: "file")
        
        request.uploadImage { (result) in
            DispatchQueue.main.async { [weak self] in
                self?.view.HideSpinner()
                switch result {
                case .success(let response):
                    print(response.body ?? [:])
                    self?.imageUrl = (response.body ?? [:])["location"] as! String
                    self?.view.HideSpinner()
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
