//
//  PateintEditViewController+UITextFieldExtension.swift
//  Growth99
//
//  Created by Nitin Auti on 28/02/23.
//

import Foundation
import UIKit

extension PateintEditViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == firsNameTextField {
            guard let textField = firsNameTextField.text, !textField.isEmpty else {
                firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
                return
            }
            guard let firstName = firsNameTextField.text, let firstNameValidate = viewModel?.isLastName(firstName), firstNameValidate else {
                firsNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
                return
            }
        } else if (textField == lastNameTextField) {
            guard let textField = lastNameTextField.text, !textField.isEmpty else  {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
                return
            }
            guard let lastName = lastNameTextField.text, let lastNameValidate = viewModel?.isLastName(lastName), lastNameValidate else {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
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
        } else if (textField == genderTextField) {
            guard let gender  = genderTextField.text,  !gender.isEmpty else {
                genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == firsNameTextField {
            guard let textField = firsNameTextField.text, !textField.isEmpty else {
                firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
                return
            }
        } else if (textField == lastNameTextField) {
            guard let textField = lastNameTextField.text, !textField.isEmpty else  {
                lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
                return
            }
            
        } else if (textField == phoneNumberTextField) {
            guard let phoneNumber  = phoneNumberTextField.text, !phoneNumber.isEmpty else {
                phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }
            
        } else if (textField == genderTextField) {
            guard let gender  = genderTextField.text, !gender.isEmpty else {
                genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
                return
            }
        }
    }
}
