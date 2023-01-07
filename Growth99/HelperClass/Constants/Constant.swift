//
//  Constant.swift
//  Growth99
//
//  Created by nitin auti on 03/11/22.
//

import Foundation

struct Constant {
    
    struct ErrorMessage {
        static let emailEmptyError = "Email is required"
        static let emailInvalidError = "Email is Invalid"
        static let passwordEmptyError = "Password is Required"
        static let passwordInvalidError = "Password is Invalide"
        static let genderEmptyError = "Gender is required"
        static let repeatPasswordEmptyError = "Repeat password is Required."
        static let repeatPasswordInvalidError = "Repeat password is Invalide."
        static let firstNameEmptyError = "First Name is required."
        static let lastNameEmptyError = "Last Name is required."
        static let phoneNumberEmptyError = "Phone number is required."
        static let phoneNumberInvalidError = "Phone number is Invalide"
        static let businessnameEmptyError = "Business name is required."
        static let confirmPasswordEmptyError = "Confirm password is Required."
        static let ConfirmPasswordInvalidError = "Confirm password is Invalide."
        static let PasswordMissmatchError = "Password must match."
        static let ConfirmationCodeInvalidError = "ConfirmationCode is Required."
        static let oldPasswordEmptyError = "Old Password is required."
        static let termsConditionsUrl = "https://growth99.com/terms-and-conditions/"
        static let privacyPolicyUrl = "https://growth99.com/privacy-policy/"
        static let privacyText = "I agree to Growth99 Terms & Conditions and Privacy Policy"

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
        static let appointment = "Add Appointment"
        static let calender = "Calendar"
        static let clinics = "Clinics"
        static let categories = "Categories"
        static let addCategories = "Create Category"
        static let editCategories = "Edit Category"
        static let services = "Services"
        static let users = "Users"
        static let tasks = "Tasksv"
        static let homeScreen = "Home"
        static let createUser = "Create User"
        static let leadTriggers = "Lead Triggers"
        static let appointmentTriggers = "Appointment Triggers"
        static let moreEvents = " More Events"
        static let calenderAccessDenied = "Access denied"
        static let unexpectedError = "Unexpected Error"
        static let calenderDefault = "Default"
        static let calenderNotDefault = "Notdefault"
        static let vacationTitle = "Vacantion Schedule"
        static let workingScheduleTitle = "Working Schedule"
        static let changePasswordTitle = "Change Password"
        static let workingSchedule = "working"
        static let selectDay = "Select day"
        static let days = "days"
        static let chooseFromTime = "Please choose from time"
        static let chooseToTime = "Please choose to time"
        static let chooseFromDate = "Please choose from date"
        static let chooseToDate = "Please choose to date"
        static let addCategorie = "Categorie add sucessfully"
        static let workingScheduleUpdate = "Working schedule updated sucessfully"
        static let vacationScheduleUpdate = "Vacation schedule updated sucessfully"
        static let clinicsRequired = "Clinics are required."
        static let categoryNameRequired = "Category Name is required."
    }
    
    struct CreateLead {
        static let emailEmptyError = "The Email field is required."
        static let emailInvalidError = "Please Input Valid Email!"
        static let firstNameEmptyError = "The First Name field is required."
        static let lastNameEmptyError = "The Last Name field is required."
        static let phoneNumberEmptyError = "The Phone Number field is required."
        static let phoneNumberInvalidError = "Please Input Valid Number!"
    }
    
    struct ViewIdentifier {
        static let dropDownCustomTableViewCell = "DropDownCustomTableViewCell"
        static let vacationsHeadeView = "VacationsHeadeView"
        static let vacationsCustomTableViewCell = "VacationsCustomTableViewCell"
        static let workingCustomTableViewCell = "WorkingCustomTableViewCell"
        static let dailyViewController = "DailyViewController"
        static let addEventViewController = "AddEventViewController"
        static let eventsTableViewCell = "EventsTableViewCell"
        static let calenderViewController = "CalenderViewController"
    }    
}
