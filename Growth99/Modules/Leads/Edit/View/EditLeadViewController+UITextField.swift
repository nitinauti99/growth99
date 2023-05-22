//
//  EditLeadViewController+UITextField.swift
//  Growth99
//
//  Created by Nitin Auti on 10/04/23.
//

import Foundation
import UIKit

extension EditLeadViewController: UITextFieldDelegate  {
    
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
        
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
            
            guard let firstName = nameTextField.text, let firstNameValidate = viewModel?.isValidFirstName(firstName), firstNameValidate else {
                nameTextField.showError(message: Constant.ErrorMessage.nameInvalidError)
                return
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
            guard let phoneNumber  = phoneNumberTextField.text, !phoneNumber.isEmpty else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }
            
            guard let phoneNumber  = phoneNumberTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberValidate else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
                return
            }
            
        } else if (textField == ammountTextField) {
            guard let phoneNumber  = ammountTextField.text, !phoneNumber.isEmpty else {
                ammountTextField.showError(message: Constant.ErrorMessage.ammountEmptyError)
                return
            }
            
            guard let ammount = ammountTextField.text, let ammountValide = viewModel?.isValidAmmount(ammount), ammountValide else {
                ammountTextField.showError(message: Constant.ErrorMessage.ammountInvalidError)
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
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
