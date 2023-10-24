//
//  TriggerEditDetailModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation

struct TriggerEditDetailModel: Codable {
    let cellType: String?
    let LastName: String?
}

struct TriggerEditDetailListModel : Codable {
    let userDTOList : [UserDTOListEditTrigger]?
    let smsTemplateDTOList : [SmsTemplateEditDTOListTrigger]?
    let emailTemplateDTOList : [EmailEditTemplateDTOListTrigger]?
}

struct EmailEditTemplateDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let emailTarget : String?
    let templateFor : String?
}

struct SmsTemplateEditDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let smsTarget : String?
    let templateFor : String?
}

struct UserDTOListEditTrigger : Codable, Equatable {
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

struct TriggerEditTagListModel: Codable, Equatable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
}

struct TriggerEditCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
}

struct TriggerEditEQuotaCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
    let tenantId : Int?
}

struct TriggerEditQuestionnaireModel : Codable, Equatable {
    let name : String?
    let id : Int?
}

struct TriggerEditCreateModel : Codable {
    let name : String?
    let moduleName : String?
    let triggeractionName : String?
    let triggerConditions : [String]?
    let triggerData : [TriggerEditCreateData]?
    let landingPageNames : [EditLandingPageNamesModel]?
    let forms : [EditLandingPageNamesModel]?
    let sourceUrls : [TriggerEditCreateSourceUrls]?
    let leadTags : [MassEmailSMSTagListModelEdit]?
    let isTriggerForLeadStatus : Bool?
    let fromLeadStatus : [String]?
    let toLeadStatus : String?
}

struct TriggerEditAppointmentCreateModel : Codable {
    let name : String?
    let moduleName : String?
    let triggeractionName : String?
    let triggerConditions : [String]?
    let triggerData : [TriggerEditAppointmentCreateData]?
    let landingPageNames : [LandingPageNamesModel]?
    let forms : [LandingPageNamesModel]?
    let sourceUrls : [TriggerCreateSourceUrls]?
    let leadTags : [MassEmailSMSTagListModelEdit]?
    let isTriggerForLeadStatus : Bool?
    let fromLeadStatus : [String]?
    let toLeadStatus : String?
}

struct TriggerEditAppointmentCreateData : Codable {
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
    let startTime : String?
    let endTime : String?
    let deadline : String?
}

struct TriggerEditCreateData : Codable {
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
    let deadline : String?
}

struct TriggerEditCreateSourceUrls : Codable {
    let sourceUrl : String?
    let id : Int?
}

struct EditLandingPageNamesModel : Codable, Equatable {
    let name : String?
    let id : Int?
}

struct TriggerEditModel : Codable {
    let id : Int?
    let sourceUrls : [Int]?
    let patientTags : [Int]?
    let triggerConditions : [String]?
    let forms : [Int]?
    let isTriggerForLeadStatus : Bool?
    let toLeadStatus : String?
    let triggerData : [TriggerEditData]?
    let landingPages : [Int]?
    let moduleName : String?
    let source : String?
    let executionStatus : String?
    let patientStatus : String?
    let fromLeadStatus : [String]?
    let leadTags : [Int]?
    let triggerActionName : String?
    let name : String?
}

struct TriggerEditData : Codable, Equatable {
    let id : String?
    let timerType : String?
    let triggerTarget : String?
    let triggerFrequency : String?
    let actionIndex : Int?
    let dateType : String?
    let triggerTime : Int?
    let showBorder : Bool?
    let userId : String?
    let scheduledDateTime : String?
    let triggerTemplate : Int?
    let addNew : Bool?
    let endTime : String?
    let triggerType : String?
    let taskName : String?
    let startTime : String?
    let orderOfCondition : Int?
    let type: String?
    
    init(id: String?, timerType: String?, triggerTarget: String?, triggerFrequency: String?, actionIndex: Int?, dateType: String?, triggerTime: Int?, showBorder: Bool?, userId: String?, scheduledDateTime: String?, triggerTemplate: Int?, addNew: Bool?, endTime: String?, triggerType: String?, taskName: String?, startTime: String?, orderOfCondition: Int?, type: String?) {
        self.id = id
        self.timerType = timerType
        self.triggerTarget = triggerTarget
        self.triggerFrequency = triggerFrequency
        self.actionIndex = actionIndex
        self.dateType = dateType
        self.triggerTime = triggerTime
        self.showBorder = showBorder
        self.userId = userId
        self.scheduledDateTime = scheduledDateTime
        self.triggerTemplate = triggerTemplate
        self.addNew = addNew
        self.endTime = endTime
        self.triggerType = triggerType
        self.taskName = taskName
        self.startTime = startTime
        self.orderOfCondition = orderOfCondition
        self.type = type
    }
}

