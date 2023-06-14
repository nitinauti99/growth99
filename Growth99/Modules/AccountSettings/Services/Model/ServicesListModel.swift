//
//  ServicesListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct ServiceListModel: Codable {
    let serviceList: [ServiceList]?
}

struct ServiceList: Codable, Equatable {
    let createdAt: String?
    let updatedBy: String?
    let createdBy: String?
    let name: String?
    let id: Int?
    let position: Int?
    let serviceId: Int?
    let serviceName: String?
    let categoryName: String?
    let categoryId: Int?
    let updatedAt: String?
}

struct ConsentListModel: Codable, Equatable {
    let createdAt: String?
    let updatedBy: String?
    let createdBy: String?
    let name: String?
    let id: Int?
    let updatedAt: String?
}

struct QuestionnaireListModel: Codable, Equatable {
    let createdAt: String?
    let isContactForm: Bool?
    let name: String?
    let id: Int?
    let isG99ReviewForm: Bool?
}

struct ServiceDetailModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let durationInMinutes : Int?
    let serviceCost : Double?
    let serviceURL : String?
    let description : String?
    let imageUrl : String?
    let isDefault : Bool?
    let defaultServiceId : Int?
    let position : Int?
    let serviceCategory : ServiceCategory?
    let clinics : [ClinicsServices]?
    let consents : [ServiceConsents]?
    let questionnaires : [ServiceQuestionnaires]?
    let preBookingCost : Double?
    let isPreBookingCostAllowed : Bool?
    let showInPublicBooking : Bool?
    let priceVaries : Bool?
    let serviceName : String?
    let serviceId : String?
}

struct ClinicsServices : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let clinic : Clinic?
}

struct ServiceConsents : Codable, Equatable {
    let id : Int?
    let updatedAt : String?
    let body : String?
    let isCustom : String?
    let isDefault : Bool?
    let tenantId : Int?
    let defaultConsentId : Int?
    let specialization : String?
    let tag : String?
    let deleted : Bool?
    let createdBy : CreatedBy?
    let generic : Bool?
    let updatedBy : UpdatedBy?
    let createdAt : String?
    let name : String?
    let specializationId : String?
}

struct ServiceQuestionnaires : Codable, Equatable {
    let backgroundImageUrl : String?
    let id : Int?
    let titleColor : String?
    let tenantId : Int?
    let enableModernUi : Bool?
    let showLogo : Bool?
    let popupLabelColor : String?
    let identifier : String?
    let googleAnalyticsGlobalCode : String?
    let isCustom : String?
    let updatedBy : UpdatedBy?
    let isDefault : String?
    let description : String?
    let subHeading : String?
    let createdAt : String?
    let hideFieldTitle : Bool?
    let appButtonForegroundColor : String?
    let thankYouPageMessageContactForm : String?
    let configureThankYouMessageInLandingPage : Bool?
    let isContactForm : String?
    let showTitle : Bool?
    let css : String?
    let deleted : Bool?
    let googleAnalyticsGlobalCodeUrl : String?
    let name : String?
    let popupTitleColor : String?
    let thankYouPageMessageLandingPage : String?
    let thankYouPageUrlLandingPage : String?
    let chatQuestionnaire : Bool?
    let configureThankYouMessageInContactForm : Bool?
    let thankYouPageUrlVC : String?
    let showTextForComposer : Bool?
    let defaultQuestionnaireId : Int?
    let buttonBackgroundColor : String?
    let submitButtonText : String?
    let thankYouPageMessageVC : String?
    let textForComposer : String?
    let createdBy : CreatedBy?
    let buttonForegroundColor : String?
    let appButtonBackgroundColor : String?
    let appTitleColor : String?
    let isLeadForm : String?
    let inputBoxShadowColor : String?
    let configureThankYouMessageInVC : Bool?
    let backgroundImages : [String]?
    let showThankYouPageUrlLinkInLandingPage : String?
    let questionnaireSource : String?
    let trackCode : String?
    let landingPageName : String?
    let showThankYouPageUrlLinkInContactForm : String?
    let isPublic : Bool?
    let activeSideColor : String?
    let updatedAt : String?
    let isG99ReviewForm : Bool?
    let thankYouPageUrl : String?
    let showThankYouPageUrlLinkInVC : String?}
