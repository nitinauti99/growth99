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
        static let passwordMissmatchError = "Confirm password should be same as password"
        static let genderEmptyError = "Gender is required"
        static let repeatPasswordEmptyError = "Repeat password is Required."
        static let repeatPasswordInvalidError = "Repeat password is Invalide."
        static let nameEmptyError = "Name is required."
        static let firstNameEmptyError = "First Name is required."
        static let firstNameInvalidError = "First Name is Invalide."
        static let lastNameInvalidError = "Last Name is Invalide."
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
    
    struct SideMenu {
        static let logout = "Logout"
        static let helpTraining = "Help and Training"
    }
    
    struct Profile {
        static let appointment = "Add Appointment"
        static let editAppointment = "Edit Appointment"
        static let calender = "Calendar"
        static let clinics = "Clinics"
        static let createClinic = "Create Clinic"
        static let createService = "Create Service"
        static let categories = "Categories"
        static let addCategories = "Create Category"
        static let editCategories = "Edit Category"
        static let services = "Services"
        static let users = "Users"
        static let pateint = "Patients List"
        static let patientDetail = " Patient Detail "
        static let emailTemplatesList = "Email Templates List"
        static let FormsList = "Forms"
        static let smsTemplateList = "SMS Templates List"
        static let consentsTemplatesList = "Consents"
        static let leadTemplates = "Lead Templates"
        static let appointmentTemplates = "Appointment Templates"
        static let eventTemplates = "Event Templates"
        static let massEmailTemplates = "Mass Email Templates"
        static let Questionnarie = " Questionnarie "
        static let tasks = "  Tasks  "
        static let Consents = "  Consents  "
        static let AssignConsent = "Assign Consent"
        static let appointmentDetail = "Appointment"
        static let deleteConcents = "Delete Consent"
        static let tasksDetail = "Tasks Detail"
        static let patientTags = "Patient Tags"
        static let Timeline = "Timeline"
        static let appointmentTrigger = "Appointment"
        static let leads = "leads"
        static let searchList = "Search..."
        static let homeScreen = "Home"
        static let triggerActive = "ACTIVE"
        static let createUser = "Create User"
        static let triggers = "Triggers"
        static let formBuilder = "Form Builder"
        static let leadTriggers = "Lead Triggers"
        static let triggersList = "Triggers List"
        static let appointmentTriggers = "Appointment Triggers"
        static let moreEvents = " More Events"
        static let bookingHistory = "Booking History"
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
        static let tableViewEmptyText = "There is no data to show."
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
        static let emptyEventsTableViewCell = "EmptyEventsTableViewCell"
        static let calenderViewController = "CalenderViewController"
    }    
}
