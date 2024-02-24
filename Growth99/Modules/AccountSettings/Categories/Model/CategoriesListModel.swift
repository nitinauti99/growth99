//
//  CategoriesListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct CategoriesListModel: Codable {
    let serviceCategoryList: [ServiceCategoryList] // change model from
}

struct ServiceCategoryList: Codable {
    let createdAt: String?
    let updatedBy: String?
    let createdBy: String?
    let name: String?
    let tenantId: Int?
    let id: Int?
    let updatedAt: String?
}

struct CategoriesAddEditModel: Codable {
    let createdAt: String?
    let updatedAt: String?
    let createdBy: CreatedBy?
    let updatedBy: UpdatedBy?
    let deleted: Bool?
    let tenantId: Int?
    let id: Int?
    let clinics : [ClinicsServices]?
    let name: String?
    let isDefault: Bool?
    let defaultServiceCategoryId: Int?
    let specialization: String?
}

struct CategeroryDeleteModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CategeroryCreatedBy?
    let updatedBy : CategeroryUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let durationInMinutes : Int?
    let serviceCost : Double?
    let serviceURL : String?
    let description : String?
    let alDescription : String?
    let imageUrl : String?
    let isDefault : Bool?
    let defaultServiceId : String?
    let position : Int?
    let serviceCategory : CategeroryServiceCategory?
    let clinics : [CategeroryClinics]?
    let consents : [CategeroryConsents]?
    let questionnaires : [CategeroryQuestionnaires]?
    let preBookingCost : Double?
    let isPreBookingCostAllowed : Bool?
    let showInPublicBooking : Bool?
    let priceVaries : Bool?
    let showDepositOnPublicBooking : Bool?
    let serviceId : String?
    let serviceName : String?
}

struct CategeroryBusinessHours : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CategeroryCreatedBy?
    let updatedBy : CategeroryUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let dayOfWeek : String?
    let openHour : String?
    let closeHour : String?
}

struct CategeroryClinic : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CategeroryCreatedBy?
    let updatedBy : CategeroryUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let contactNumber : String?
    let address : String?
    let city : String?
    let state : String?
    let country : String?
    let notificationEmail : String?
    let notificationSMS : String?
    let timezone : String?
    let about : String?
    let clinicUrl : String?
    let facebook : String?
    let instagram : String?
    let twitter : String?
    let yelpUrl : String?
    let giftCardDetail : String?
    let giftCardUrl : String?
    let website : String?
    let googleMyBusiness : String?
    let googlePlaceId : String?
    let isDefault : Bool?
    let businessHours : [CategeroryBusinessHours]?
    let appointmentNotificationReminderHours : Int?
    let appointmentNotificationReminderDays : Int?
    let appointmentNotificationFeedbackHours : Int?
    let sendRemainderEmail : Bool?
    let feedbackQuestionnaire : String?
    let ccPatientEmail : Bool?
    let showPayButton : Bool?
    let showBookAppointmentButton : Bool?
    let appointmentBlockWithinHours : Int?
    let appReviewCode : String?
    let g99AppReviewCode : String?
    let g99OverrideButtonCode : String?
    let reviewPerPage : Int?
    let reviewButtonCode : String?
    let paymentLink : String?
    let appointmentUrl : String?
    let countryCode : String?
    let currency : String?
    let preBookingOnly : Bool?
    let defaultPreBookingCost : Int?
    let isProviderBasedAppointment : Bool?
    let seamlessPatientExperience : Bool?
    let numberOfSlotsAvailable : Int?
    let cacheUpdateDate : String?
    let css : String?
    let currencySymbol : String?
    let isReviewPublished : Bool?
    let disableVirtualAppointment : Bool?
    let clinicVacationSchedules : [ClinicVacationSchedules]?
    let priceVaries : Bool?
    let sendPatientWelcomeEmail : Bool?
    let notesLabel : String?
    let notesRequiredOptional : Bool?
    let showCategoriesOnAppointmentBookingPage : Bool?
}

struct CategeroryClinics : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CategeroryCreatedBy?
    let updatedBy : CategeroryUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let clinic : CategeroryClinic?
}

struct CategeroryConsents : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CategeroryCreatedBy?
    let updatedBy : CategeroryUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultConsentId : Int?
    let name : String?
    let body : String?
    let isDefault : Bool?
    let tag : String?
    let isCustom : Bool?
    let specialization : String?
    let generic : Bool?
    let specializationId : String?
    let serviceId : String?
    let serviceIds : String?
}

struct CategeroryCreatedBy : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct CategeroryQuestionnaires : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CategeroryCreatedBy?
    let updatedBy : CategeroryUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultQuestionnaireId : Int?
    let name : String?
    let isPublic : Bool?
    let chatQuestionnaire : Bool?
    let questionnaireSource : String?
    let isContactForm : Bool?
    let isG99ReviewForm : Bool?
    let isLeadForm : Bool?
    let showTitle : Bool?
    let buttonBackgroundColor : String?
    let buttonForegroundColor : String?
    let activeSideColor : String?
    let titleColor : String?
    let popupTitleColor : String?
    let popupLabelColor : String?
    let inputBoxShadowColor : String?
    let showTextForComposer : Bool?
    let textForComposer : String?
    let hideFieldTitle : Bool?
    let css : String?
    let isDefault : Bool?
    let identifier : String?
    let isCustom : Bool?
    let trackCode : String?
    let googleAnalyticsGlobalCode : String?
    let googleAnalyticsGlobalCodeUrl : String?
    let landingPageName : String?
    let thankYouPageUrl : String?
    let appButtonBackgroundColor : String?
    let appButtonForegroundColor : String?
    let appTitleColor : String?
    let submitButtonText : String?
    let showThankYouPageUrlLinkInContactForm : Bool?
    let showThankYouPageUrlLinkInVC : Bool?
    let showThankYouPageUrlLinkInLandingPage : Bool?
    let thankYouPageUrlVC : String?
    let thankYouPageUrlLandingPage : String?
    let configureThankYouMessageInContactForm : Bool?
    let thankYouPageMessageContactForm : String?
    let configureThankYouMessageInLandingPage : Bool?
    let thankYouPageMessageLandingPage : String?
    let configureThankYouMessageInVC : Bool?
    let thankYouPageMessageVC : String?
    let enableModernUi : Bool?
    let description : String?
    let subHeading : String?
    let backgroundImageUrl : String?
    let showLogo : Bool?
    let backgroundImages : [String]?
}

struct CategeroryUpdatedBy : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct CategeroryServiceCategory : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CategeroryCreatedBy?
    let updatedBy : CategeroryUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let clinics : [CategeroryClinics]?
    let name : String?
    let isDefault : Bool?
    let defaultServiceCategoryId : String?
    let specialization : String?
}
