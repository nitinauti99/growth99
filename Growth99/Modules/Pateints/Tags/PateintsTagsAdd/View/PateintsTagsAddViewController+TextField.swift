//
//  PateintsTagsAddViewController+TextField.swift
//  Growth99
//
//  Created by Nitin Auti on 11/04/23.
//

import Foundation

extension PateintsTagsAddViewController: UITextFieldDelegate  {
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == PateintsTagsTextField {
            guard let textField = PateintsTagsTextField.text, !textField.isEmpty else {
                PateintsTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
            
            if let isValuePresent = self.pateintsTagsList?.filter({ $0.name?.lowercased() == self.PateintsTagsTextField.text}), isValuePresent.count > 0 {
                PateintsTagsTextField.showError(message: "Tag with this name already present.")
                saveButton.isEnabled = false
                return
            }
        }
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
       
        if textField == PateintsTagsTextField {
            saveButton.isEnabled = true

            guard let textField = PateintsTagsTextField.text, !textField.isEmpty else {
                PateintsTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
            
            if let isValuePresent = self.pateintsTagsList?.filter({ $0.name?.lowercased() == (self.PateintsTagsTextField.text)?.lowercased()}), isValuePresent.count > 0 {
                PateintsTagsTextField.showError(message: "Tag with this name already present.")
                saveButton.isEnabled = false
                return
            }
        }
    }
    
}
