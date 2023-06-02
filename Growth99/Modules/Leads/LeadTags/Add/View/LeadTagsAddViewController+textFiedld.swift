//
//  LeadTagsAddViewController+textFiedld.swift
//  Growth99
//
//  Created by Nitin Auti on 11/04/23.
//

import Foundation

extension LeadTagsAddViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
       
        if textField == LeadTagsTextField {
            guard let textField = LeadTagsTextField.text, !textField.isEmpty else {
                LeadTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
            
            if let isValuePresent = self.leadTagsList?.filter({ $0.name?.lowercased() == self.LeadTagsTextField.text?.lowercased() }), isValuePresent.count > 0 {
                LeadTagsTextField.showError(message: "Tag with this name already present.")
                return
            }
        }
    }
    
}
