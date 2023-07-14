//
//  ServicesListDetailViewController+TextField.swift
//  Growth99
//
//  Created by Exaze Technologies on 14/04/23.
//

import Foundation
import UIKit

extension ServicesListDetailViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        func validateURLTextField(_ textField: CustomTextField, errorMessage: String) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            let isURLValid = regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && (textField.text?.contains(".")) ?? false
            if isURLValid {
                textField.hideError()
                submitButton.isEnabled = true
            } else {
                textField.showError(message: errorMessage)
                submitButton.isEnabled = false
            }
        }
        
        switch textField {
        case serviceNameTextField:
            guard let serviceName = serviceNameTextField.text, !serviceName.isEmpty else {
                serviceNameTextField.showError(message: "Service Name is required.")
                submitButton.isEnabled = false
                return
            }
            
            guard let serviceNameContain = servicesAddViewModel?.getAddServiceListData.contains(where: { $0.name == serviceName}), !serviceNameContain else {
                serviceNameTextField.showError(message: "Service with this name already present.")
                submitButton.isEnabled = false
                return
            }
            
        case selectClinicTextField:
            guard let clinicName = selectClinicTextField.text, !clinicName.isEmpty else {
                selectClinicTextField.showError(message: "Clinic Name is required.")
                submitButton.isEnabled = false
                return
            }
            
        case serviceCategoryTextField:
            guard let category = serviceCategoryTextField.text, !category.isEmpty else {
                serviceCategoryTextField.showError(message: "Service Category is required.")
                submitButton.isEnabled = false
                return
            }
            
        case serviceUrlTextField:
            if let text = serviceUrlTextField.text, !text.isEmpty {
                validateURLTextField(serviceUrlTextField, errorMessage: "Service URL is invalid")
            } else {
                serviceUrlTextField.hideError()
            }
            
        default:
            break
        }
        
        submitButton.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        func showError(for textField: CustomTextField, message: String) {
            textField.showError(message: message)
        }
        
        if textField == serviceNameTextField {
            guard let serviceName = serviceNameTextField.text, !serviceName.isEmpty else {
                showError(for: serviceNameTextField, message: "Service Name is required.")
                return
            }

        } else if textField == selectClinicTextField {
            guard let clinicName = selectClinicTextField.text, !clinicName.isEmpty else  {
                showError(for: selectClinicTextField, message: "Clinic Name is required.")
                return
            }
        } else if textField == serviceCategoryTextField {
            guard let category = serviceCategoryTextField.text, !category.isEmpty else {
                showError(for: serviceCategoryTextField, message: "Service Category is required.")
                return
            }
        }
    }
}
