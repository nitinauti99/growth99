//
//  TriggerDetailModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation

struct TriggerDetailModel: Codable {
    let cellType: String?
    let LastName: String?
}

struct TriggerDetailListModel : Codable {
    let userDTOList : [UserDTOListTrigger]?
    let smsTemplateDTOList : [SmsTemplateDTOListTrigger]?
    let emailTemplateDTOList : [EmailTemplateDTOListTrigger]?
}

struct EmailTemplateDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let emailTarget : String?
    let templateFor : String?
}

struct SmsTemplateDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let smsTarget : String?
    let templateFor : String?
}

struct UserDTOListTrigger : Codable, Equatable {
    let gender : String?
    let phone : String?
    let firstName : String?
    let id : Int?
    let provider : String?
    let profileImageUrl : String?
    let email : String?
    let designation : String?
    let description : String?
    let lastName : String?
}

struct TriggerTagListModel: Codable, Equatable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
}

struct TriggerCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
}

struct TriggerEQuotaCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
    let tenantId : Int?
}

struct TriggerQuestionnaireModel : Codable, Equatable {
    let name : String?
    let id : Int?
}

struct TriggerCreateModel : Codable {
    let name : String?
    let moduleName : String?
    let triggeractionName : String?
    let triggerConditions : [String]?
    let triggerData : [TriggerCreateData]?
    let landingPageNames : [LandingPageNamesModel]?
    let forms : [LandingPageNamesModel]?
    let sourceUrls : [TriggerCreateSourceUrls]?
    let leadTags : [MassEmailSMSTagListModelEdit]?
    let isTriggerForLeadStatus : Bool?
    let fromLeadStatus : String?
    let toLeadStatus : String?
}

struct TriggerAppointmentCreateModel : Codable {
    let name : String?
    let moduleName : String?
    let triggeractionName : String?
    let triggerConditions : [String]?
    let triggerData : [TriggerAppointmentCreateData]?
    let landingPageNames : [LandingPageNamesModel]?
    let forms : [LandingPageNamesModel]?
    let sourceUrls : [TriggerCreateSourceUrls]?
    let leadTags : [MassEmailSMSTagListModelEdit]?
    let isTriggerForLeadStatus : Bool?
    let fromLeadStatus : String?
    let toLeadStatus : String?
}

struct TriggerAppointmentCreateData : Codable {
    let actionIndex : Int?
    let addNew : Bool?
    let triggerTemplate : Int?
    let triggerType : String?
    let triggerTarget : String?
    let triggerTime : Int?
    let triggerFrequency : String?
    let taskName : String?
    let showBorder : Bool?
    let orderOfCondition : Int?
    let dateType : String?
}

struct TriggerCreateData : Codable {
    let actionIndex : Int?
    let addNew : Bool?
    let triggerTemplate : Int?
    let triggerType : String?
    let triggerTarget : String?
    let triggerTime : Int?
    let triggerFrequency : String?
    let taskName : String?
    let showBorder : Bool?
    let orderOfCondition : Int?
    let dateType : String?
    let timerType : String?
    let startTime : String?
    let endTime : String?
}

struct TriggerCreateSourceUrls : Codable {
    let sourceUrl : String?
    let id : Int?
}

struct LandingPageNamesModel : Codable, Equatable {
    let name : String?
    let id : Int?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if name != nil {
            dictionary["name"] = name
        }
        if id != nil {
            dictionary["id"] = id
        }
        return dictionary
    }
    
}
