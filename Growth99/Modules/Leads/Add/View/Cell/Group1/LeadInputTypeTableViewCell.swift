//
//  InputTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class LeadInputTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var inputeTypeTextField: CustomTextField!
    @IBOutlet weak var asteriskSign: UILabel!
   
    var patientQuestionAnswersList : PatientQuestionAnswersList?
    var viewModel: CreateLeadViewModelProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        self.viewModel = questionarieVM
        let questionarie = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.patientQuestionAnswersList = questionarie
        self.questionnaireName.text = questionarie?.questionName
        self.inputeTypeTextField.placeholder = questionarie?.questionName
        self.asteriskSign.isHidden = true
        if questionarie?.required == true {
            self.asteriskSign.isHidden = false
        }
    }
}

extension LeadInputTypeTableViewCell: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if self.patientQuestionAnswersList?.questionType == "Input" {
            guard let textField = inputeTypeTextField.text, let isValid = viewModel?.isValidTextFieldData(textField, regex: self.patientQuestionAnswersList?.regex ?? String.blank), isValid == true else {
                if self.patientQuestionAnswersList?.validationMessage != nil {
                    self.inputeTypeTextField.showError(message: self.patientQuestionAnswersList?.validationMessage)
                }else{
                    self.inputeTypeTextField.showError(message: "The \(inputeTypeTextField.placeholder ?? "") field is required.")
                }
                return
            }
        }else{
            if textField == inputeTypeTextField {
                guard let textField = inputeTypeTextField.text, !textField.isEmpty else {
                    inputeTypeTextField.showError(message: "The \(inputeTypeTextField.placeholder ?? "") field is required.")
                    return
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputeTypeTextField {
            guard let textField = inputeTypeTextField.text, !textField.isEmpty else {
                inputeTypeTextField.showError(message: "The \(inputeTypeTextField.placeholder ?? "") field is required.")
                return
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == inputeTypeTextField {
            guard let textField = inputeTypeTextField.text, !textField.isEmpty else {
                inputeTypeTextField.showError(message: "The \(inputeTypeTextField.placeholder ?? "") field is required.")
                return
            }
        }
    }

}
