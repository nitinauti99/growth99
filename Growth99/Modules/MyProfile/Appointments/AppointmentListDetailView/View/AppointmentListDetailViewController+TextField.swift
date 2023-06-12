//
//  AppointmentListDetailViewController+TextField.swift
//  Growth99
//
//  Created by Exaze Technologies on 11/04/23.
//

import Foundation
import UIKit

extension AppointmentListDetailViewController: UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == firstNameTextField {
            guard let textField = firstNameTextField.text, !textField.isEmpty else {
                firstNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
                return
            }
            guard let firstName = firstNameTextField.text, let firstNameValidate = eventViewModel?.validateName(firstName), firstNameValidate else {
                firstNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
                return
            }
        } else if (textField == lastNameTextField) {
            guard let textField = lastNameTextField.text, !textField.isEmpty else  {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
                return
            }
            guard let lastName = lastNameTextField.text, let lastNameValidate = eventViewModel?.validateName(lastName), lastNameValidate else {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
                return
            }
        } else if (textField == phoneNumberTextField) {
            guard let phoneNumber  = phoneNumberTextField.text, !phoneNumber.isEmpty else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }
            guard let phoneNumber  = phoneNumberTextField.text, let phoneNumberValidate = eventViewModel?.isValidPhoneNumber(phoneNumber), phoneNumberValidate else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
                return
            }
        }
        else if (textField == emailTextField) {
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
                firstNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
                return
            }
        } else if (textField == lastNameTextField) {
            guard let textField = lastNameTextField.text, !textField.isEmpty else  {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
                return
            }
            
        } else if (textField == emailTextField) {
            guard let emailText = emailTextField.text, !emailText.isEmpty else {
                emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
            
        } else if (textField == phoneNumberTextField) {
            guard let phoneNumber  = phoneNumberTextField.text, !phoneNumber.isEmpty else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }
        }
    }
}
