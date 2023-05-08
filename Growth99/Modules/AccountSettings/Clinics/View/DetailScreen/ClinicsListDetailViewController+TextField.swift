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
        if textField == clinicNameTextField {
            guard let textField = clinicNameTextField.text, !textField.isEmpty else {
                clinicNameTextField.showError(message: "Clinic Name is required.")
                return
            }
        } else if (textField == contactNumberTextField) {
            guard let textField = contactNumberTextField.text, !textField.isEmpty else  {
                contactNumberTextField.showError(message: "Contact Number is required.")
                return
            }
        } else if (textField == addressField) {
            guard let textField  = addressField.text, !textField.isEmpty else {
                addressField.showError(message: "Address is required.")
                return
            }
            
            guard let address = addressField.text, let addressValidate = viewModel?.isFirstName(address), addressValidate else {
                addressField.showError(message: "Address is invalid.")
                return
            }
        } else if (textField == notificationEmailTextField) {
            guard let emailText = notificationEmailTextField.text, !emailText.isEmpty else {
                notificationEmailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
            guard let emailText = notificationEmailTextField.text, let emailValidate = viewModel?.isValidEmail(emailText), emailValidate else {
                notificationEmailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
                return
            }
        } else if (textField == timeZoneTextField) {
            guard let timeZone = timeZoneTextField.text, !timeZone.isEmpty else {
                timeZoneTextField.showError(message: "Timezone is required.")
                return
            }
            guard let timeZone = timeZoneTextField.text, let timeZoneValidate = viewModel?.isFirstName(timeZone), timeZoneValidate else {
                timeZoneTextField.showError(message: "Timezone is invalid.")
                return
            }
        }
        else if (textField == currencyTextField) {
            guard let currencyText = currencyTextField.text, !currencyText.isEmpty else {
                currencyTextField.showError(message: "Currency is required.")
                return
            }
            guard let currency = currencyTextField.text, let currencyValidate = viewModel?.isFirstName(currency), currencyValidate else {
                currencyTextField.showError(message: "Currency is invalid.")
                return
            }
        }
        else if (textField == countryCodeTextField) {
            guard let countryCode = countryCodeTextField.text, !countryCode.isEmpty else {
                countryCodeTextField.showError(message: "Country Code is required.")
                return
            }
            guard let country = countryCodeTextField.text, let countryValidate = viewModel?.isFirstName(country), countryValidate else {
                countryCodeTextField.showError(message: "Country Code is invalid.")
                return
            }
        } else if (textField == websiteURLTextField) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            guard regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && ((textField.text?.contains(".")) != nil) else {
                websiteURLTextField.showError(message: "Website URL is invalid.")
                return
            }
        } else if (textField == appointmentURLTextField) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            guard regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && ((textField.text?.contains(".")) != nil) else {
                appointmentURLTextField.showError(message: "Appointment URL is invalid.")
                return
            }
        } else if (textField == giftcardURLTextField) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            guard regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && ((textField.text?.contains(".")) != nil) else {
                giftcardURLTextField.showError(message: "Gift Card URL is invalid.")
                return
            }
        } else if (textField == instagramURLTextField) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            guard regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && ((textField.text?.contains(".")) != nil) else {
                instagramURLTextField.showError(message: "Instagram URL is invalid.")
                return
            }
        } else if (textField == twitterURLTextField) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            guard regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && ((textField.text?.contains(".")) != nil) else {
                twitterURLTextField.showError(message: "Twitter URL is invalid.")
                return
            }
        } else if (textField == paymentLinkTextField) {
            let regex = try! NSRegularExpression(pattern: "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?", options: [])
            guard regex.firstMatch(in: textField.text ?? "", options: [], range: NSRange(location: 0, length: textField.text?.utf16.count ?? 0)) != nil && ((textField.text?.contains(".")) != nil) else {
                paymentLinkTextField.showError(message: "Payment Link is invalid.")
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == clinicNameTextField {
            guard let textField = clinicNameTextField.text, !textField.isEmpty else {
                clinicNameTextField.showError(message: "Clinic Name is required.")
                return
            }
        } else if (textField == contactNumberTextField) {
            guard let textField = contactNumberTextField.text, !textField.isEmpty else  {
                contactNumberTextField.showError(message: "Contact Number is required.")
                return
            }
        } else if (textField == addressField) {
            guard let textField  = addressField.text, !textField.isEmpty else {
                addressField.showError(message: "Address is required.")
                return
            }
        }
        else if (textField == notificationEmailTextField) {
            guard let emailText = notificationEmailTextField.text, !emailText.isEmpty else {
                notificationEmailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
        }
        else if (textField == timeZoneTextField) {
            guard let timeZone = timeZoneTextField.text, !timeZone.isEmpty else {
                timeZoneTextField.showError(message: "Timezone is required.")
                return
            }
        }
        else if (textField == currencyTextField) {
            guard let currencyText = currencyTextField.text, !currencyText.isEmpty else {
                currencyTextField.showError(message: "Currency is required.")
                return
            }
        }
        else if (textField == countryCodeTextField) {
            guard let countryCode = countryCodeTextField.text, !countryCode.isEmpty else {
                countryCodeTextField.showError(message: "Country Code is required.")
                return
            }
        }
    }
}
