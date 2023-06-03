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
        if textField == serviceNameTextField {
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
        } else if (textField == selectClinicTextField) {
            guard let textField = selectClinicTextField.text, !textField.isEmpty else  {
                selectClinicTextField.showError(message: "Clinic Name are required.")
                submitButton.isEnabled = false
                return
            }
        } else if (textField == serviceDurationTextField) {
            guard let textField  = serviceDurationTextField.text, !textField.isEmpty else {
                serviceDurationTextField.showError(message: "Service duration is required.")
                submitButton.isEnabled = false
                return
            }
        } else if (textField == serviceCategoryTextField) {
            guard let emailText = serviceCategoryTextField.text, !emailText.isEmpty else {
                serviceCategoryTextField.showError(message: "Service Category is required.")
                submitButton.isEnabled = false
                return
            }
        } else if (textField == serviceCostTextField) {
            guard let timeZone = serviceCostTextField.text, !timeZone.isEmpty else {
                serviceCostTextField.showError(message: "Service Cost is required.")
                submitButton.isEnabled = false
                return
            }
        } else if (textField == serviceUrlTextField) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            guard regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && ((textField.text?.contains(".")) != nil) else {
                serviceUrlTextField.showError(message: "Service URL is invalid.")
                submitButton.isEnabled = false
                return
            }
        }
        submitButton.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == serviceNameTextField {
            guard let serviceName = serviceNameTextField.text, !serviceName.isEmpty else {
                serviceNameTextField.showError(message: "Service Name is required.")
                return
            }
            guard let serviceNameContain = servicesAddViewModel?.getAddServiceListData.contains(where: { $0.name == serviceName}), !serviceNameContain else {
                serviceNameTextField.showError(message: "Service with this name already present.")
                return
            }
        } else if (textField == selectClinicTextField) {
            guard let textField = selectClinicTextField.text, !textField.isEmpty else  {
                selectClinicTextField.showError(message: "Clinic Name are required.")
                return
            }
        } else if (textField == serviceDurationTextField) {
            guard let textField  = serviceDurationTextField.text, !textField.isEmpty else {
                serviceDurationTextField.showError(message: "Service duration is required.")
                return
            }
        } else if (textField == serviceCategoryTextField) {
            guard let emailText = serviceCategoryTextField.text, !emailText.isEmpty else {
                serviceCategoryTextField.showError(message: "Service Category is required. ")
                return
            }
        } else if (textField == serviceCostTextField) {
            guard let timeZone = serviceCostTextField.text, !timeZone.isEmpty else {
                serviceCostTextField.showError(message: "Service Cost is required.")
                return
            }
        }
    }
}
