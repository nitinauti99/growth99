//
//  BusinessModel.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation

struct BusinessModel: Codable {
    let createdAt: String?
    let updatedAt: String?
    let createdBy: CreatedBy?
    let updatedBy: UpdatedBy?
    let deleted: Bool?
    let id: Int?
    let name: String?
    let logoUrl: String?
    let deleteBusiness: Bool?
}

struct BusinessSubDomainModel : Codable {
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
    let stripeApplicationFee : String?
    let monitorWebsite : String?
    let monitorNotificationEmail : String?
    let monitorNotificationPhoneNumber : String?
    let monitorStatus : String?
    let statusFromDate : String?
    let notifyAfterMinute : Int?
    let lastNotifyDateTime : String?
    let paymentRefundableBeforeHours : Int?
    let paymentRefundable : Bool?
    let refundablePaymentPercentage : Double?
    let subDomainName : String?
    let subDomainWebsiteTemplateId : Int?
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
}

struct BusinessResponseModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : String?
    let updatedBy : BusinessUpdatedBy?
    let deleted : Bool?
    let id : Int?
    let name : String?
    let logoUrl : String?
    let deleteBusiness : Bool?
    let clinics : [String]?
    let stripeApplicationFee : String?
    let monitorWebsite : String?
    let monitorNotificationEmail : String?
    let monitorNotificationPhoneNumber : String?
    let monitorStatus : String?
    let statusFromDate : String?
    let notifyAfterMinute : Int?
    let lastNotifyDateTime : String?
    let paymentRefundableBeforeHours : Int?
    let paymentRefundable : Bool?
    let refundablePaymentPercentage : Int?
    let subDomainName : String?
    let subDomainWebsiteTemplateId : Int?
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
    let showPatientDetailsOnSinglePage : Bool?
    let notificationSMSNumber : String?
    let notificationEmail : String?
    let enableTwoWaySMS : Bool?
    let getTwilioNumber : Bool?
    let countryCode : String?
    let agency : Agency?
}

struct Agency : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : BusinessCreatedBy?
    let updatedBy : BusinessUpdatedBy?
    let deleted : Bool?
    let id : Int?
    let name : String?
    let logoUrl : String?
    let poweredByText : String?
    let defaultAgency : Bool?
}

struct BusinessCreatedBy : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct BusinessUpdatedBy : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}
