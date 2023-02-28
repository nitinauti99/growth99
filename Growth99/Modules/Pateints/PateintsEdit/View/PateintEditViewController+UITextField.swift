//
//  PateintEditViewController+UITextFieldExtension.swift
//  Growth99
//
//  Created by Nitin Auti on 28/02/23.
//

import Foundation
import UIKit

extension PateintEditViewController: UITextFieldDelegate  {
    
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == firsNameTextField {
            guard let firstName = firsNameTextField.text, let firstNameValidate = viewModel?.isValid(testStr: firstName), firstNameValidate else {
                firsNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
                return
            }
            
        }else if (textField == lastNameTextField) {
            guard let lastName = lastNameTextField.text, let lastNameValidate = viewModel?.isValid(testStr: lastName), lastNameValidate else {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
                return
            }
       
        }else if (textField == emailTextField) {
            guard let emailText = emailTextField.text, !emailText.isEmpty else {
                emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
            guard let emailText = emailTextField.text, let emailValidate = viewModel?.isValidEmail(emailText), emailValidate else {
                emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
                return
            }
       
        }else if (textField == phoneNumberTextField) {
            guard let phoneNumber  = phoneNumberTextField.text, !phoneNumber.isEmpty else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }
            
            guard let phoneNumber  = phoneNumberTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberValidate else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
                return
            }
       
        }else if (textField == genderTextField) {
            guard let gender  = genderTextField.text,  !gender.isEmpty else {
                genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
                return
            }
        }
    }
}
