//
//  PateintDetailViewController_UITextField.swift
//  Growth99
//
//  Created by Nitin Auti on 28/02/23.
//

import Foundation
import UIKit

extension PateintDetailViewController: UITextFieldDelegate  {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
          if (textField == phoneNumber) {
            guard let phoneNumFiled  = phoneNumber.text, !phoneNumFiled.isEmpty else {
                phoneNumber.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }

            guard let phoneNo  = phoneNumber.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNo), phoneNumberValidate else {
                phoneNumber.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
                return
            }

        }
    }
}
