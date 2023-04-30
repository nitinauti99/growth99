//
//  MediaTagsAddViewController+textField.swift
//  Growth99
//
//  Created by Nitin Auti on 30/04/23.
//

import Foundation

extension MediaTagsAddViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
       
        if textField == MediaTagsTextField {
            guard let textField = MediaTagsTextField.text, !textField.isEmpty else {
                MediaTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
            
            if let isValuePresent = self.mediaTagsList?.filter({ $0.name?.lowercased() == self.MediaTagsTextField.text}), isValuePresent.count > 0 {
                MediaTagsTextField.showError(message: "Tag with this name already present.")
                return
            }
        }
    }
    
}
