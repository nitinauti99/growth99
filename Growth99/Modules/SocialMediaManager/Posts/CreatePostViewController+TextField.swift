//
//  CreatePostViewController+TextField.swift
//  Growth99
//
//  Created by Nitin Auti on 29/04/23.
//

import Foundation

extension CreatePostViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if (textField ==  hashtagTextField) {
            if let textField = hashtagTextField, textField.text == "" {
                hashtagTextField.showError(message: Constant.ErrorMessage.hashTagEmptyError)
                return
            }
            
            if let isFirstName =  self.viewModel?.isValidHashTag(self.hashtagTextField.text ?? ""), isFirstName == false  {
                hashtagTextField.showError(message: Constant.ErrorMessage.hashTagInvalidError)
                return
            }
            
        } else if (textField ==  labelTextField) {
            if textField == labelTextField, textField.text == "" {
                labelTextField.showError(message: "Label is required")
            }
        } else if (textField == socialChannelTextField) {
            if textField == socialChannelTextField, textField.text == "" {
                self.socialChannelTextField.showError(message: "Social channel is required")
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField ==  labelTextField) {
            if textField == labelTextField, textField.text == "" {
                labelTextField.showError(message: "Label is required")
            }
        } else if (textField == socialChannelTextField) {
            if textField == socialChannelTextField, textField.text == "" {
                self.socialChannelTextField.showError(message: "Social channel is required")
            }
        }
    }
    
}
