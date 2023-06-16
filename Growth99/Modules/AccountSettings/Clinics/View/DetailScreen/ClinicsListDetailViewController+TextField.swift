//
//  ClinicsListDetailViewController+TextField.swift
//  Growth99
//
//  Created by Exaze Technologies on 12/04/23.
//

import Foundation
import UIKit

extension ClinicsListDetailViewController: UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contactNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
    
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
        case clinicNameTextField:
            guard let text = clinicNameTextField.text, !text.isEmpty else {
                clinicNameTextField.showError(message: "Clinic Name is required.")
                submitButton.isEnabled = false
                return
            }
        case contactNumberTextField:
            guard let text = contactNumberTextField.text, !text.isEmpty else  {
                contactNumberTextField.showError(message: "Contact Number is required.")
                submitButton.isEnabled = false
                return
            }
        case addressField:
            guard let text = addressField.text, !text.isEmpty else {
                addressField.showError(message: "Address is required.")
                submitButton.isEnabled = false
                return
            }
        case timeZoneTextField:
            guard let text = timeZoneTextField.text, !text.isEmpty else {
                timeZoneTextField.showError(message: "Timezone is required.")
                submitButton.isEnabled = false
                return
            }
        case currencyTextField:
            guard let text = currencyTextField.text, !text.isEmpty else {
                currencyTextField.showError(message: "Currency is required.")
                submitButton.isEnabled = false
                return
            }
        case websiteURLTextField:
            if let text = websiteURLTextField.text, !text.isEmpty {
                validateURLTextField(websiteURLTextField, errorMessage: "Website URL is invalid.")
            } else {
                websiteURLTextField.hideError()
            }
        case appointmentURLTextField:
            if let text = appointmentURLTextField.text, !text.isEmpty {
                validateURLTextField(appointmentURLTextField, errorMessage: "Appointment URL is invalid.")
            } else {
                appointmentURLTextField.hideError()
            }
        case giftcardURLTextField:
            if let text = giftcardURLTextField.text, !text.isEmpty {
                validateURLTextField(giftcardURLTextField, errorMessage: "Gift Card URL is invalid.")
            } else {
                giftcardURLTextField.hideError()
            }
        case instagramURLTextField:
            if let text = instagramURLTextField.text, !text.isEmpty {
                validateURLTextField(instagramURLTextField, errorMessage: "Instagram URL is invalid.")
            } else {
                instagramURLTextField.hideError()
            }
        case twitterURLTextField:
            if let text = twitterURLTextField.text, !text.isEmpty {
                validateURLTextField(twitterURLTextField, errorMessage: "Twitter URL is invalid.")
            } else {
                twitterURLTextField.hideError()
            }
        case paymentLinkTextField:
            if let text = paymentLinkTextField.text, !text.isEmpty {
                validateURLTextField(paymentLinkTextField, errorMessage: "Payment Link is invalid.")
            } else {
                paymentLinkTextField.hideError()
            }
        default:
            break
        }
        
        submitButton.isEnabled = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case clinicNameTextField:
            guard let text = clinicNameTextField.text, !text.isEmpty else {
                clinicNameTextField.showError(message: "Clinic Name is required.")
                return
            }
        case contactNumberTextField:
            guard let text = contactNumberTextField.text, !text.isEmpty else {
                contactNumberTextField.showError(message: "Contact Number is required.")
                return
            }
        case addressField:
            guard let text = addressField.text, !text.isEmpty else {
                addressField.showError(message: "Address is required.")
                return
            }
        case timeZoneTextField:
            guard let timeZone = timeZoneTextField.text, !timeZone.isEmpty else {
                timeZoneTextField.showError(message: "Timezone is required.")
                return
            }
        case currencyTextField:
            guard let currencyText = currencyTextField.text, !currencyText.isEmpty else {
                currencyTextField.showError(message: "Currency is required.")
                return
            }
        default:
            break
        }
    }

}
