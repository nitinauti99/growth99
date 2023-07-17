//
//  HomeViewContoller+UITextField.swift
//  Growth99
//
//  Created by Nitin Auti on 13/03/23.
//

import Foundation
import UIKit

extension HomeViewContoller: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            // Check if the backspace key was pressed
            if string.isEmpty && range.length == 1 {
                textField.text = "" // Clear the text field's content
                return false // Prevent further processing
            }
            let characterCount = newString.count
            return characterCount <= 10
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
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
