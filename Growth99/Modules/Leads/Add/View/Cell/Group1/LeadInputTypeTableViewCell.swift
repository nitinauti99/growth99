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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
        self.inputeTypeTextField.placeholder = questionarieVM?.questionName
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let regex = Constant.Regex.phone
        let isPhoneNo = NSPredicate(format:"SELF MATCHES %@", regex)
        return isPhoneNo.evaluate(with: phoneNumber)
    }
    
    func isValidte(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = Constant.Regex.email
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension LeadInputTypeTableViewCell: UITextFieldDelegate {
    @IBAction func textFieldDidChange(_ textField: UITextField) {

        if inputeTypeTextField.placeholder == "Phone Number" {
            guard let textField = inputeTypeTextField.text, !textField.isEmpty else {
                inputeTypeTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }

            guard let phoneNumber = inputeTypeTextField.text, self.isValidPhoneNumber(phoneNumber) else {
                inputeTypeTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
                return
            }

        }  else if (inputeTypeTextField.placeholder == "Email") {
            guard let email  = inputeTypeTextField.text, !email.isEmpty else {
                inputeTypeTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }

            guard let email  = inputeTypeTextField.text,self.isValidEmail(email) else {
                inputeTypeTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
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

}
