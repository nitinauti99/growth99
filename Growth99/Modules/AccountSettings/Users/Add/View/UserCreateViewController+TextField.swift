//
//  UserCreateViewController+TextField.swift
//  Growth99
//
//  Created by Nitin Auti on 28/04/23.
//

import Foundation

extension UserCreateViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = Int()
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        
        if  textField == phoneNumberTextField {
            maxLength = 10
            phoneNumberTextField.hideError()
            return newString.length <= maxLength
        }
        return true
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if (textField ==  firsNameTextField) {
            if let textField = firsNameTextField, textField.text == "" {
                firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            }
            
            if let isFirstName =  self.viewModel?.isValidFirstName(self.firsNameTextField.text ?? ""), isFirstName == false  {
                firsNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
            }
     
        } else if (textField ==  lastNameTextField) {
            if textField == lastNameTextField, textField.text == "" {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            }
            
            if let isLastName =  self.viewModel?.isValidLastName(self.lastNameTextField.text ?? ""), isLastName == false {
                self.lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
            }
     
        } else if (textField == emailTextField) {
            guard let emailText = emailTextField.text, !emailText.isEmpty else {
                emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
            guard let emailText = emailTextField.text, let emailValidate = viewModel?.isValidEmail(emailText), emailValidate else {
                emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
                return
            }
       
        } else if (textField == phoneNumberTextField) {
            
            if textField == phoneNumberTextField, textField.text == "" {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            }
            if textField == phoneNumberTextField, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumberTextField.text ?? String.blank), phoneNumberValidate == false {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            }
        }
    }
    
}
