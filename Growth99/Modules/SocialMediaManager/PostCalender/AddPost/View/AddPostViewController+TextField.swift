//
//  AddPostViewController+TextField.swift
//  Growth99
//
//  Created by Exaze Technologies on 14/04/23.
//

import Foundation
import UIKit

extension AddPostViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == hastagTextField {
            if let textField = hastagTextField, textField.text == "" {
                hastagTextField.showError(message: Constant.ErrorMessage.hashTagEmptyError)
                return
            }
          
            if let isFirstName = self.addPostCalenderViewModel?.isValidHashTag(self.hastagTextField.text ?? ""), isFirstName == false  {
                hastagTextField.showError(message: Constant.ErrorMessage.hashTagInvalidError)
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == hastagTextField {
            guard let textField = hastagTextField.text, !textField.isEmpty else {
                hastagTextField.showError(message: "Hashtag is required.")
                return
            }
        }
    }
}
