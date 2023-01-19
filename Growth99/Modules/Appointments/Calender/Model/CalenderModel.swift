//
//  CalenderModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 16/01/23.
//

import Foundation

struct ProviderListModel: Codable {
    let userDTOList: [UserDTOList]?
}

struct UserDTOList: Codable, Equatable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let profileImageUrl: String?
    let email: String?
    let phone: String?
    let designation: String?
    let description: String?
    let provider: String?
}

struct CalenderInfoListModel: Codable {
    let appointmentDTOList: [AppointmentDTOList]?
}

struct AppointmentDTOList: Codable, Equatable {
    let id: Int?
    let patientId: Int?
    let patientFirstName: String?
    let patientLastName: String?
    let patientPhone: String?
    let patientEmail: String?
    let patientNotes: String?
    let clinicId: Int?
    let clinicName: String?
    let timeZone: String?
    let serviceList: [ServiceList]?
    let providerId: Int?
    let providerName: String?
    let paymentStatus: String?
    let appointmentStatus: String?
    let appointmentType: String?
    let appointmentStartDate: String?
    let appointmentEndDate: String?
    let appointmentCreatedDate: String?
    let appointmentUpdatedDate: String?
    let notes: String?
    let source: String?
    let paymentSource: String?
    let defaultClinic: Bool?
}


struct NewAppoinmentModel: DictionaryEncodable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
    let notes: String?
    let clinicId: Int?
    let serviceIds: [Int]?
    let providerId: Int?
    let date: String?
    let time: String?
    let appointmentType: String?
    let source: String?
    let appointmentDate: String?
}

protocol DictionaryEncodable: Encodable {}

extension DictionaryEncodable {
    func dictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                return nil
        }
        return dict
    }
}


struct AppoinmentModel: Codable {
    let data: Data?
    let statusCode: Int?
}

struct Data : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let appointmentConfirmationStatus : String?
    let appointmentConfirmationDate : String?
    let clinic : Clinic?
    let provider : Provider?
    let patient : Patient?
    let notes : String?
    let appointmentDate : String?
    let appointmentEndDate : String?
    let services : String?
    let appointmentType : String?
    let paymentStatus : String?
    let totalCost : Int?
    let source : String?
    let walkInAppointment : Bool?
    let preBookingCost : Int?
    let preBookingOnly : Bool?
    let preBookingConfirmed : Bool?
    let amountPaid : Int?
    let amountToPaid : Int?
    let paymentSource : String?
    
}

struct BusinessHours : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let dayOfWeek : String?
    let openHour : String?
    let closeHour : String?
}

struct Clinic : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
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
    let businessHours : [BusinessHours]?
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
    let reviewButton : String?
    let paymentLink : String?
    let appointmentUrl : String?
    let countryCode : String?
    let currency : String?
    let preBookingOnly : Bool?
    let defaultPreBookingCost : Double?
    let isProviderBasedAppointment : Bool?
    let seamlessPatientExperience : Bool?
    let numberOfSlotsAvailable : Int?
    let cacheUpdateDate : String?
    let css : String?
    let currencySymbol : String?
    let isReviewPublished : Bool?
    let disableVirtualAppointment : String?
}

struct Consents : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultConsentId : Int?
    let name : String?
    let body : String?
    let isDefault : Bool?
    let tag : String?
    let isCustom : String?
}

struct Patient : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let username : String?
    let email : String?
    let emailVerified : Bool?
    let emailVerificationToken : String?
    let firstName : String?
    let lastName : String?
    let phone : String?
    let profileImageUrl : String?
    let roles : [String]?
    let userType : String?
    let gender : String?
    let dateOfBirth : String?
    let addressLine1 : String?
    let addressLine2 : String?
    let city : String?
    let state : String?
    let country : String?
    let zipcode : String?
    let notes : String?
    let description : String?
    let designation : String?
    let timezone : String?
    let serviceCategory : String?
    let isProvider : String?
    let clinics : [String]?
    let services : [String]?
    let userServiceCategories : [String]?
    let allowCreateBusiness : String?
    let patientTags : [String]?
    let patientStatus : String?
}

struct Provider : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let username : String?
    let email : String?
    let emailVerified : Bool?
    let emailVerificationToken : String?
    let firstName : String?
    let lastName : String?
    let phone : String?
    let profileImageUrl : String?
    let roles : [Roles]?
    let userType : String?
    let gender : String?
    let dateOfBirth : String?
    let addressLine1 : String?
    let addressLine2 : String?
    let city : String?
    let state : String?
    let country : String?
    let zipcode : String?
    let notes : String?
    let description : String?
    let designation : String?
    let timezone : String?
    let serviceCategory : String?
    let isProvider : Bool?
    let clinics : [Clinics]?
    let services : [Services]?
    let userServiceCategories : [UserServiceCategories]?
    let allowCreateBusiness : Bool?
    let patientTags : [String]?
    let patientStatus : String?
}

struct Questionnaires : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultQuestionnaireId : Int?
    let name : String?
    let isPublic : Bool?
    let chatQuestionnaire : Bool?
    let questionnaireSource : String?
    let isContactForm : String?
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
    let isDefault : String?
    let identifier : String?
    let isCustom : String?
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
}

struct Service : Codable {
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
    let defaultServiceId : String?
    let position : Int?
    let serviceCategory : ServiceCategory?
    let clinics : [Clinics]?
    let consents : [Consents]?
    let questionnaires : [Questionnaires]?
    let preBookingCost : Double?
    let isPreBookingCostAllowed : Bool?
    let showInPublicBooking : Bool?
    let serviceId : String?
    let serviceName : String?
}

struct ServiceCategory : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let clinics : [Clinics]?
    let name : String?
    let isDefault : Bool?
    let defaultServiceCategoryId : String?
    let specialization : String?
}
