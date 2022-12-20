//
//  Constant.swift
//  Growth99
//
//  Created by nitin auti on 03/11/22.
//

import Foundation

struct Constant {
    
    struct Login {
        static let emailEmptyError = "Email is required"
        static let emailInvalidError = "Email is Invalid"
        static let passwordEmptyError = "Password is Required"
        static let passwordInvalidError = "Password is Invalide"
        static let termsConditionsUrl = "https://growth99.com/terms-and-conditions/"
        static let privacyPolicyUrl = "https://growth99.com/privacy-policy/"
    }
    
    struct Registration{
        static let privacyText = "I agree to Growth99 Terms & Conditions and Privacy Policy"
        static let firstNameEmptyError = "First Name is required."
        static let lastNameEmptyError = "Last Name is required."
        static let emailEmptyError = "Email is required."
        static let emailInvalidError = "Email is Invalid."
        static let phoneNumberEmptyError = "Phone number is required."
        static let phoneNumberInvalidError = "Phone number is Invalide"
        static let passwordEmptyError = "Password is Required."
        static let passwordInvalidError = "Password is Invalide."
        static let repeatPasswordEmptyError = "Repeat password is Required."
        static let repeatPasswordInvalidError = "Repeat password is Invalide."
        static let businessnameEmptyError = "Business name is required."
    }
    
    struct VerifyForgotPassword {
        static let emailEmptyError = "Email is required"
        static let emailInvalidError = "Email is Invalid"
        static let passwordEmptyError = "Password is Required"
        static let passwordInvalidError = "Password is Invalide"
        static let confirmPasswordEmptyError = "Confirm password is Required."
        static let ConfirmPasswordInvalidError = "Confirm password is Invalide."
        static let PasswordMissmatchError = "Password must match."
        static let ConfirmationCodeInvalidError = "ConfirmationCode is Required."
        
    }
    
    struct ChangePassword {
        static let oldPasswordEmptyError = "Old Password is required."
        static let newPasswordEmptyError = "Password is required."
        static let confirmPasswordEmptyError = "Confirm password is required."
        static let passwordMissmatchError = "Password must match."
    }
    
    /// Required  Server status from requests url configured for what ever is needed
    struct status {
        static let OK = "OK"
        static let NOK = "NOK"
        static let REQUEST_FAIL = "FAIL"
        static let NETWORK_UNAVAILABLE = "NETWORK_UNAVAILABLE"
        static let RESOURCE_UNAVAILABLE = "RESOURCE_UNAVAILABLE"
    }
    
    struct Profile {
        static let vacationTitle = "Vacantion Schedule"
        static let workingScheduleTitle = "Working Schedule"
        static let changePasswordTitle = "Change Password"
        static let workingSchedule = "working"
    }
    
    struct CreateLead {
        static let emailEmptyError = "The Email field is required."
        static let emailInvalidError = "Please Input Valid Email!"
        static let firstNameEmptyError = "The First Name field is required."
        static let lastNameEmptyError = "The Last Name field is required."
        static let phoneNumberEmptyError = "The Phone Number field is required."
        static let phoneNumberInvalidError = "Please Input Valid Number!"
    }
}
