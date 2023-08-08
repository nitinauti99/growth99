
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

struct CalendarInfoListModel: Codable {
    let appointments: [AppointmentDTOList]?
    let unreadCount: Int?
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


struct NewAppoinmentModel: Codable {
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

struct EditAppoinmentModel: Codable {
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
    let appointmentConfirmationStatus: String?
}

struct CalenderEditAppoinmentModel: Codable {
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

struct AppoinmentCreateModel: Codable {
    let data: AppoinmentModel?
    let statusCode: Int?
}

struct AppoinmentModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let appointmentConfirmationStatus : String?
    let appointmentConfirmationDate : String?
    let clinic : AppoinmentClinic?
    let provider : AppoinmentProvider?
    let patient : AppoinmentPatient?
    let notes : String?
    let appointmentDate : String?
    let appointmentEndDate : String?
    let services : [AppoinmentServices]?
    let appointmentType : String?
    let paymentStatus : String?
    let totalCost : Double?
    let source : String?
    let walkInAppointment : Bool?
    let preBookingCost : Double?
    let preBookingOnly : Bool?
    let preBookingConfirmed : Bool?
    let amountPaid : Int?
    let amountToPaid : Int?
    let paymentSource : String?
    let timeOffset : String?
    let appointmentRead : Bool?
}

struct AppoinmentAgency : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : String?
    let updatedBy : AppoinmentUpdatedBy?
    let deleted : Bool?
    let id : Int?
    let name : String?
    let logoUrl : String?
    let poweredByText : String?
    let defaultAgency : Bool?
    let disableAgency : Bool?
}

struct AppoinmentBusinessHours : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let dayOfWeek : String?
    let openHour : String?
    let closeHour : String?
}

struct AppoinmentClinic : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
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
    let businessHours : [AppoinmentBusinessHours]?
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
    let defaultPreBookingCost : String?
    let isProviderBasedAppointment : Bool?
    let seamlessPatientExperience : Bool?
    let numberOfSlotsAvailable : Int?
    let cacheUpdateDate : String?
    let css : String?
    let currencySymbol : String?
    let isReviewPublished : Bool?
    let disableVirtualAppointment : Bool?
    let clinicVacationSchedules : [String]?
    let priceVaries : Bool?
    let sendPatientWelcomeEmail : Bool?
    let notesLabel : String?
    let notesRequiredOptional : Bool?
    let showCategoriesOnAppointmentBookingPage : Bool?
}

struct AppoinmentClinics : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let clinic :  AppoinmentClinic?
}

struct AppoinmentConsents : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
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

struct AppoinmentCreatedBy : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct AppoinmentPatient : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
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
    let agency : AppoinmentAgency?
    let isPassWordSent : Bool?
    let smsChatStatus : String?
}

struct AppoinmentProvider : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
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
    let roles : [AppoinmentRoles]?
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
    let clinics : [AppoinmentClinics]?
    let services : [AppoinmentServices]?
    let userServiceCategories : [AppoinmentUserServiceCategories]?
    let allowCreateBusiness : String?
    let patientTags : [String]?
    let patientStatus : String?
    let agency : AppoinmentAgency?
    let isPassWordSent : Bool?
    let smsChatStatus : String?
}

struct AppoinmentRoles : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : String?
    let updatedBy : String?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let permissions : [String]?
    let defaultRole : String?
}

struct AppoinmentService : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
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
    let serviceCategory : AppoinmentServiceCategory?
    let clinics : [AppoinmentClinics]?
    let consents : [AppoinmentConsents]?
    let questionnaires : [Questionnaires]?
    let preBookingCost : Double?
    let isPreBookingCostAllowed : Bool?
    let showInPublicBooking : Bool?
    let priceVaries : Bool?
    let showDepositOnPublicBooking : Bool?
    let serviceName : String?
    let serviceId : String?
}

struct AppoinmentServiceCategory : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let clinics : [AppoinmentClinics]?
    let name : String?
    let isDefault : Bool?
    let defaultServiceCategoryId : String?
    let specialization : String?
}

struct AppoinmentServices : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let service : AppoinmentService?
    let name : String?
    let durationInMinutes : Int?
    let serviceCost : Double?
}

struct AppoinmentUpdatedBy : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct AppoinmentUserServiceCategories : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : AppoinmentCreatedBy?
    let updatedBy : AppoinmentUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let serviceCategory : AppoinmentServiceCategory?
}

struct AppoinmentData : Codable {
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
    let services : [Service]?
    let appointmentType : String?
    let paymentStatus : String?
    let totalCost : Int?
    let source : String?
    let walkInAppointment : Bool?
    let preBookingCost : Double?
    let preBookingOnly : Bool?
    let preBookingConfirmed : Bool?
    let amountPaid : Int?
    let amountToPaid : Int?
    let paymentSource : String?
    let timeOffset : String?
    let appointmentRead : Bool?
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
    let feedbackQuestionnaire : FeedbackQuestionnaire?
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
    let disableVirtualAppointment : Bool?
}
struct FeedbackQuestionnaire : Codable {
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
    let isDefault : String?
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
    let isCustom : Bool?
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
    let allowCreateBusiness : Bool?
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
    let isDefault : String?
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
    let defaultServiceId : Int?
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
    let defaultServiceCategoryId : Int?
    let specialization : String?
    let timezone : String?
}


struct AddEventPhoneModel: Codable {
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String?
}
