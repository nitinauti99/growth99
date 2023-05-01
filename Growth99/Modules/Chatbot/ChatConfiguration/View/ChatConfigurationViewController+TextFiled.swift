//
//  ChatConfigurationViewController+TextFiled.swift
//  Growth99
//
//  Created by Nitin Auti on 30/04/23.
//

import Foundation
import UIKit

extension ChatConfigurationViewController: UITextFieldDelegate  {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if textField == botName {
            guard let textField = botName.text, !textField.isEmpty else {
                botName.showError(message: "Bot Name is required.")
                return
            }
        }
        
        if textField == appointmentBookingUrl {
            guard let url  = appointmentBookingUrl.text, let phoneURLValidate = viewModel?.isURLValid(url: url), phoneURLValidate else {
                appointmentBookingUrl.showError(message: "Booking URL is invalid (should start with http)")
                return
            }
        }
        
        if textField == weeksToShow {
            guard let textField = weeksToShow.text, !textField.isEmpty else {
                weeksToShow.showError(message: " Weeks to show is required.")
                return
            }
        }
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == botName {
            guard let textField = botName.text, !textField.isEmpty else {
                botName.showError(message: "Bot Name is required.")
                return
             }
         }
     }
}

extension ChatConfigurationViewController: UITextViewDelegate  {
    
    func textViewDidChange(_ textField: UITextView) {
        
        if textField == defaultWelcomeMessage {
            guard let textField = defaultWelcomeMessage.text, !textField.isEmpty else {
                defaultWelcomeMessageLBI.isHidden = false
                return
            }
            self.defaultWelcomeMessageLBI.isHidden = true
       
        }else if textField == formMessage {
            guard let textField = formMessage.text, !textField.isEmpty else {
                formMessageLBI.isHidden = false
                return
            }
            self.formMessageLBI.isHidden = true
       
        }else if textField == welcomeMessage {
            guard let textField = welcomeMessage.text, !textField.isEmpty else {
                welcomeMessageLBI.isHidden = false
                return
            }
            self.welcomeMessageLBI.isHidden = true
      
        }else if textField == faqNotFoundMessage {
            guard let textField = faqNotFoundMessage.text, !textField.isEmpty else {
                faqNotFoundMessageLBI.isHidden = false
                return
            }
            self.faqNotFoundMessageLBI.isHidden = true
        }
    }
}
