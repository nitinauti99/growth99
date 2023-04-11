//
//  ChangePasswordViewController+TextField.swift
//  Growth99
//
//  Created by Exaze Technologies on 11/04/23.
//

import Foundation
import UIKit

extension ChangePasswordViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == oldPasswordTextField {
            guard let textField = oldPasswordTextField.text, !textField.isEmpty else {
                oldPasswordTextField.showError(message: Constant.ErrorMessage.oldPasswordEmptyError)
                return
            }
        } else if (textField == newPasswordTextField) {
            guard let textField = newPasswordTextField.text, !textField.isEmpty else  {
                newPasswordTextField.showError(message: "New password required.")
                return
            }
            guard let passwordValidate = viewModel?.isValidPassword(newPasswordTextField.text ?? ""), passwordValidate else {
                newPasswordTextField.showError(message: "Password must contain one small character, one upper case character, one number and one of (!, @, $). It must be minimum 8 characters long.")
                return
            }
        } else if (textField == verifyPasswordTextField) {
            guard let textField = verifyPasswordTextField.text, !textField.isEmpty else  {
                verifyPasswordTextField.showError(message: "Confirm Password is required.")
                return
            }
            guard let passwordValidate = viewModel?.isValidPasswordAndCoinfirmationPassword(newPasswordTextField.text ?? "", verifyPasswordTextField.text ?? ""), passwordValidate else {
                verifyPasswordTextField.showError(message: Constant.ErrorMessage.PasswordMissmatchError)
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == oldPasswordTextField {
            guard let textField = oldPasswordTextField.text, !textField.isEmpty else {
                oldPasswordTextField.showError(message: Constant.ErrorMessage.oldPasswordEmptyError)
                return
            }
        } else if (textField == newPasswordTextField) {
            guard let textField = newPasswordTextField.text, !textField.isEmpty else  {
                newPasswordTextField.showError(message: "New password required.")
                return
            }
            
        } else if (textField == verifyPasswordTextField) {
            guard let textField  = verifyPasswordTextField.text, !textField.isEmpty else {
                verifyPasswordTextField.showError(message: "Confirm Password is required.")
                return
            }
        }
    }
}
