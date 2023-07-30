//
//  EventEditViewController+TextField.swift
//  Growth99
//
//  Created by Exaze Technologies on 14/04/23.
//

import Foundation
import UIKit

extension EventEditViewController: UITextFieldDelegate  {
    
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
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == firstNameTextField {
            guard let textField = firstNameTextField.text, !textField.isEmpty else {
                firstNameTextField.showError(message: "First Name is required.")
                return
            }
            guard let name = firstNameTextField.text, let nameValidate = eventViewModel?.validateName(name), nameValidate else {
                firstNameTextField.showError(message: "First Name is invalid.")
                return
            }
        } else if textField == lastNameTextField {
            guard let textField = lastNameTextField.text, !textField.isEmpty else {
                lastNameTextField.showError(message: "Last Name is required.")
                return
            }
            guard let name = lastNameTextField.text, let nameValidate = eventViewModel?.validateName(name), nameValidate else {
                lastNameTextField.showError(message: "Last Name is invalid.")
                return
            }
        } else if (textField == phoneNumberTextField) {
            guard let textField = phoneNumberTextField.text, !textField.isEmpty else  {
                phoneNumberTextField.showError(message: "Phone Number is required.")
                return
            }
        } else if (textField == emailTextField) {
            guard let emailText = emailTextField.text, !emailText.isEmpty else {
                emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
            guard let emailText = emailTextField.text, let emailValidate = eventViewModel?.isValidEmail(emailText), emailValidate else {
                emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == firstNameTextField {
            guard let textField = firstNameTextField.text, !textField.isEmpty else {
                firstNameTextField.showError(message: "First Name is required.")
                return
            }
        } else if textField == lastNameTextField {
            guard let textField = lastNameTextField.text, !textField.isEmpty else {
                lastNameTextField.showError(message: "Last Name is required.")
                return
            }
        } else if (textField == phoneNumberTextField) {
            guard let textField = phoneNumberTextField.text, !textField.isEmpty else  {
                phoneNumberTextField.showError(message: "Phone Number is required.")
                return
            }
        } else if (textField == emailTextField) {
            guard let emailText = emailTextField.text, !emailText.isEmpty else {
                emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
        }
    }
}
