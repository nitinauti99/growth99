//
//  ChatbotModel.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import Foundation

struct ChatConfigurationModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : String?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let morningStartTime : String?
    let morningEndTime : String?
    let noonStartTime : String?
    let noonEndTime : String?
    let eveningStartTime : String?
    let eveningEndTime : String?
    let weeksToShow : Int?
    let privacyLink : String?
    let botName : String?
    let welcomeMessage : String?
    let faqNotFoundMessage : String?
    let enableAppointment : Bool?
    let enableInPersonAppointment : Bool?
    let enableVirtualAppointment : Bool?
    let iconUrl : String?
    let backgroundColor : String?
    let foregroundColor : String?
    let longCodePhoneNumber : String?
    let scrapWebsiteUrl : String?
    let scrapWebsiteFrequency : Int?
    let scrapWebsiteDate : String?
    let imageURL : String?
    let options : [String]?
    let showPoweredBy : Bool?
    let poweredByText : String?
    let defaultWelcomeMessage : String?
    let appointmentBookingUrl : String?
    let isChatbotStatic : Bool?
    let formMessage : String?
}
