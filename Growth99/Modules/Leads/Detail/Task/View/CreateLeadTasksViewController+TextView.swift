//
//  CreateLeadTasksViewController+TextView.swift
//  Growth99
//
//  Created by Nitin Auti on 14/04/23.
//

import Foundation

extension CreateLeadTasksViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
        } else if (textField == usersTextField) {
            guard let usersText = usersTextField.text, !usersText.isEmpty else {
                usersTextField.showError(message: "Please select user")
                return
            }
            
        } else if (textField == statusTextField) {
            guard let statusField  = statusTextField.text, !statusField.isEmpty else {
                statusTextField.showError(message: "Status is required")
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
            
        } else if (textField == usersTextField) {
            guard let usersText = usersTextField.text, !usersText.isEmpty else {
                usersTextField.showError(message: "Please select user")
                return
            }
            
        } else if (textField == statusTextField) {
            guard let statusField  = statusTextField.text, !statusField.isEmpty else {
                statusTextField.showError(message: "Status is required")
                return
            }
            
        }
    }
}
