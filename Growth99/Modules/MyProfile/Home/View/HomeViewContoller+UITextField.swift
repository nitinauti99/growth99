//
//  HomeViewContoller+UITextField.swift
//  Growth99
//
//  Created by Nitin Auti on 13/03/23.
//

import Foundation
import UIKit

extension HomeViewContoller: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == firsNameTextField,  textField.text == "" {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        if textField == lastNameTextField, textField.text == "" {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
        }
    }
}
