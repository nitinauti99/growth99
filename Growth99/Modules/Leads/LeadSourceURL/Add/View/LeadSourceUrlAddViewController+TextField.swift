//
//  LeadSourceUrlAddViewController+TextField.swift
//  Growth99
//
//  Created by Exaze Technologies on 01/05/23.
//

import Foundation
import UIKit

extension LeadSourceUrlAddViewController: UITextFieldDelegate  {

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == leadSourceUrlTextField {
            guard let textField = leadSourceUrlTextField.text, !textField.isEmpty else {
                leadSourceUrlTextField.showError(message: "Source URL is required.")
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == leadSourceUrlTextField {
            guard let textField = leadSourceUrlTextField.text, !textField.isEmpty else {
                leadSourceUrlTextField.showError(message: "Source URL is required.")
                return
            }
        }
    }
}
