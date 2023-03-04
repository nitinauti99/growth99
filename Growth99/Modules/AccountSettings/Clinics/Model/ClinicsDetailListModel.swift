//
//  ClinicsDetailListModel.swift
//  Growth99
//
//  Created by Sravan Goud on 14/02/23.
//

import Foundation

struct ClinicsDetailListModel: Codable {
    let createdAt: String?
    let updatedAt: String?
    let createdBy: CreatedBy?
    let updatedBy: UpdatedBy?
    let deleted: Bool?
    let tenantId: Int?
    let id: Int?
    let name: String?
    let contactNumber: String?
    let address: String?
    let city: String?
    let state: String?
    let country: String?
    let notificationEmail: String?
    let notificationSMS: String?
    let timezone: String?
    let about: String?
    let clinicUrl: String?
    let facebook: String?
    let instagram: String?
    let twitter: String?
    let yelpUrl: String?
    let giftCardDetail: String?
    let giftCardUrl: String?
    let website: String?
    let googleMyBusiness: String?
    let googlePlaceId: String?
    let isDefault: Bool?
    let businessHours: [BusinessHours]?
    let appointmentNotificationReminderHours: Int?
    let appointmentNotificationReminderDays: Int?
    let appointmentNotificationFeedbackHours: Int?
    let sendRemainderEmail: Bool?
    let feedbackQuestionnaire: String?
    let ccPatientEmail: Bool?
    let showPayButton: Bool?
    let showBookAppointmentButton: Bool?
    let appointmentBlockWithinHours: Int?
    let appReviewCode: String?
    let g99AppReviewCode: String?
    let g99OverrideButtonCode: String?
    let reviewPerPage: Int?
    let reviewButtonCode: String?
    let paymentLink: String?
    let appointmentUrl: String?
    let countryCode: String?
    let currency: String?
    let preBookingOnly: Bool?
    let defaultPreBookingCost: Int?
    let isProviderBasedAppointment: Bool?
    let seamlessPatientExperience: Bool?
    let numberOfSlotsAvailable: Int?
    let cacheUpdateDate: String?
    let css: String?
    let currencySymbol: String?
    let isReviewPublished: Bool?
    let disableVirtualAppointment: Bool?
    let clinicVacationSchedules: [String]?
    let priceVaries: Bool?
}

struct ClinicParamModel: Codable {
    let name : String?
    let contactNumber : String?
    let address : String?
    let notificationEmail : String?
    let notificationSMS : String?
    let timezone : String?
    let isDefault : Bool?
    let about : String?
    let facebook : String?
    let instagram : String?
    let twitter : String?
    let giftCardDetail : String?
    let giftCardUrl : String?
    let website : String?
    let paymentLink : String?
    let appointmentUrl : String?
    let countryCode : String?
    let currency : String?
    let googleMyBusiness : String?
    let googlePlaceId : String?
    let yelpUrl : String?
    let businessHours : [BusinessHoursAccount]?
    let clinicUrl : String?
    
    func toDict() -> [String:Any] {
        var dictionary = [String:Any]()
        if name != nil {
            dictionary["name"] = name
        }
        if contactNumber != nil {
            dictionary["contactNumber"] = contactNumber
        }
        if address != nil {
            dictionary["address"] = address
        }
        if notificationEmail != nil {
            dictionary["notificationEmail"] = notificationEmail
        }
        if notificationSMS != nil {
            dictionary["notificationSMS"] = notificationSMS
        }
        if timezone != nil {
            dictionary["timezone"] = timezone
        }
        if isDefault != nil {
            dictionary["isDefault"] = isDefault
        }
        if about != nil {
            dictionary["about"] = about
        }
        if facebook != nil {
            dictionary["facebook"] = facebook
        }
        if instagram != nil {
            dictionary["instagram"] = instagram
        }
        if twitter != nil {
            dictionary["twitter"] = twitter
        }
        if giftCardDetail != nil {
            dictionary["giftCardDetail"] = giftCardDetail
        }
        if giftCardUrl != nil {
            dictionary["giftCardUrl"] = giftCardUrl
        }
        if website != nil {
            dictionary["website"] = website
        }
        if paymentLink != nil {
            dictionary["paymentLink"] = paymentLink
        }
        if appointmentUrl != nil {
            dictionary["appointmentUrl"] = appointmentUrl
        }
        if countryCode != nil {
            dictionary["countryCode"] = countryCode
        }
        if currency != nil {
            dictionary["currency"] = currency
        }
        if googleMyBusiness != nil {
            dictionary["googleMyBusiness"] = googleMyBusiness
        }
        if googlePlaceId != nil {
            dictionary["googlePlaceId"] = googlePlaceId
        }
        if yelpUrl != nil {
            dictionary["yelpUrl"] = yelpUrl
        }
        if clinicUrl != nil {
            dictionary["clinicUrl"] = clinicUrl
        }
        
        if businessHours != nil {
            var arrOfDict = [[String: Any]]()
            for item in businessHours! {
                arrOfDict.append(item.toDict())
            }
            dictionary["businessHours"] = arrOfDict
        }
        return dictionary
    }
    
}

struct BusinessHoursAccount: Codable {
    let dayOfWeek: String?
    let openHour: String?
    let closeHour: String?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if dayOfWeek != nil {
            dictionary["dayOfWeek"] = dayOfWeek
        }
        if openHour != nil {
            dictionary["openHour"] = openHour
        }
        if closeHour != nil {
            dictionary["closeHour"] = closeHour
        }
        return dictionary
    }
}

