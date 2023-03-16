//
//  QuestionnaireId.swift
//  Growth99
//
//  Created by nitin auti on 16/12/22.
//

import Foundation

struct QuestionnaireId : Codable {
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
    let showLogo : String?
}
