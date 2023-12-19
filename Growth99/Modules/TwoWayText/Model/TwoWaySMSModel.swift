//
//  TwoWaySMSModel.swift
//  Growth99
//
//  Created by Nitin Auti on 19/12/23.
//

import Foundation

struct TwoWaySMSModel : Codable {
    let createdAt : String?
        let updatedAt : String?
        let createdBy : CreatedBy?
        let updatedBy : UpdatedBy?
        let deleted : Bool?
        let id : Int?
        let name : String?
        let logoUrl : String?
        let deleteBusiness : Bool?
        let clinics : [String]?
        let stripeApplicationFee : Double?
        let monitorWebsite : String?
        let monitorNotificationEmail : String?
        let monitorNotificationPhoneNumber : String?
        let monitorStatus : String?
        let statusFromDate : String?
        let notifyAfterMinute : Int?
        let lastNotifyDateTime : String?
        let paymentRefundableBeforeHours : Int?
        let paymentRefundable : Bool?
        let refundablePaymentPercentage : String?
        let subDomainName : String?
        let subDomainWebsiteTemplateId : String?
        let trainingBusiness : Bool?
        let landingPageTrackCode : String?
        let googleAnalyticsGlobalCode : String?
        let googleAnalyticsGlobalCodeUrl : String?
        let dataStudioCode : String?
        let paidMediaCode : String?
        let syndicationCode : String?
        let smsLimit : Int?
        let emailLimit : Int?
        let stripeApplicationFeeType : String?
        let twilioNumber : String?
        let twilioNumberPathSid : String?
        let showNotesPopupOnLeadLoad : Bool?
        let stripeCustomerId : String?
        let showPatientDetailsOnSinglePage : Bool?
        let notificationSMSNumber : String?
        let notificationEmail : String?
        let enableTwoWaySMS : Bool?
        let getTwilioNumber : Bool?
        let countryCode : String?
        let specialization : Specialization?
        let agency : AgencySMS?
        let enableAiTwoWaySMSSuggestion : Bool?
        let enableWebsitePopUp : Bool?
        let upgradeToTwoWayText : Bool?
        let enableSmsAutoReply : Bool?
        let enableEmailNotificationForMessages : Bool?
        let dentalSpecializationOnly : Bool?
        let otherSpecialization : Bool?
        let svBusinessId : String?
        let accountSid : String?
        let questionnaireSubmissionId : String?

}

struct AgencySMS : Codable {
    let id : Int?
    let name : String?
    let logoUrl : String?
    let poweredByText : String?
    let defaultAgency : Bool?
    let disableAgency : Bool?
    let salesEmail : String?
    let customerExperienceEmail : String?
    let accountingEmail : String?
    let productEmail : String?
    let supportEmail : String?
}

struct Specialization : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let isDefault : Bool?
    let defaultSpecializationId : String?
    
}
