//
//  ConfigurationDataModel.swift
//  Growth99
//
//  Created by Nitin Auti on 19/12/23.
//

import Foundation

struct ConfigurationDataModel : Codable {
    let getTwilioNumber : Bool?
    let notificationSMSNumber : String?
    let contactSupportEmail : String?
    let otherSpecialization : Bool?
    let paidMediaReportEmail : String?
    let paymentRefundable : Bool?
    let enableSmsAutoReply : Bool?
    let googleAnalyticsGlobalCodeUrl : String?
    let syndicationCode : String?
    let subDomainName : String?
    let twilioNumber : String?
    let subDomainWebsiteTemplateId : Int?
    let termsAndConditions : String?
    let landingPageTrackCode : String?
    let countryCode : String?
    let syndicationReportEmail : String?
    let paymentRefundableBeforeHours : Int?
    let paidMediaCode : String?
    let id : Int?
    let lastNotifyDateTime : String?
    let enableTwoWaySMS : Bool?
    let dentalSpecializationOnly : Bool?
    let enableEmailNotificationForMessages : Bool?
    let agency : AgencyConfiguration?
    let privacyPolicy : String?
    let notifyAfterMinute : Int?
    let notificationEmail : String?
    let upgradeToTwoWayText : Bool?
    let logoUrl : String?
    let smsLimit : Int?
    let dataStudioCode : String?
    let dashboardAndReportEmail : String?
    let showPatientDetailsOnSinglePage : Bool?
    let deleted : Bool?
    let showNotesPopupOnLeadLoad : Bool?
    let trainingBusiness : Bool?
    let emailLimit : Int?
    let enableAiTwoWaySMSSuggestion : Bool?
    let name : String?
    let refundablePaymentPercentage : Int?
    let poweredByText : String?
    let googleAnalyticsGlobalCode : String?
    let defaultClinicId : Int?
}

struct AgencyConfiguration : Codable {
    let disableAgency : Bool?
    let productEmail : String?
    let salesEmail : String?
    let logoUrl : String?
    let defaultAgency : Bool?
    let createdAt : String?
    let supportEmail : String?
    let deleted : Bool?
    let customerExperienceEmail : String?
    let name : String?
    let poweredByText : String?
    let accountingEmail : String?
    let id : Int?
    let updatedAt : String?
}
