//
//  CreateTasksViewController+TextField.swift
//  Growth99
//
//  Created by Nitin Auti on 07/04/23.
//

import Foundation
import UIKit

extension CreateTasksViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {

        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
                    
        }else if (textField == usersTextField) {
            guard let textField = usersTextField.text, !textField.isEmpty else  {
                usersTextField.showError(message: Constant.ErrorMessage.userFiledEmptyError)
                return
            }
                
        }else if (textField == statusTextField) {
            guard let textField = statusTextField.text, !textField.isEmpty else {
                statusTextField.showError(message: Constant.ErrorMessage.statusFiledEmptyError)
                return
            }
        }
    }
    
}
