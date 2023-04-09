//
//  EditTasksViewController+TextField.swift
//  Growth99
//
//  Created by Nitin Auti on 08/04/23.
//

import Foundation
import UIKit

extension EditTasksViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
       
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
                return
            }
            guard let name = nameTextField.text, let nameValidate = viewModel?.isNameValidate(name), nameValidate else {
                nameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
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
        }
    }
}
