//
//  TriggersListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct TriggersListModel: Codable {
    let bpmnTasks : [String]?
    let bpmnEmails : [BpmnEmailsTrigger]?
    let updatedBy : String?
    let triggerActionName : String?
    let executionStatus : String?
    let smsFlag : Bool?
    let moduleName : String?
    let createdAt : String?
    let triggerConditions : [String]?
    let emailFlag : Bool?
    let createdBy : String?
    let taskFlag : Bool?
    let name : String?
    let id : Int?
    let bpmnSMS : [BpmnSMSTrigger]?
    let updatedAt : String?
    let status : String?
}

struct EmailTemplateTrigger : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByTrigger?
    let updatedBy : UpdatedByTrigger?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultEmailTemplateId : Int?
    let name : String?
    let body : String?
    let subject : String?
    let emailTemplateName : String?
    let defaultEmailTemplate : Bool?
    let active : Bool?
    let templateFor : String?
    let emailTarget : String?
    let questionnaire : String?
    let identifier : String?
    let isCustom : String?
    let isCloneTemplate : String?
}

struct BpmnEmailsTrigger : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByTrigger?
    let updatedBy : UpdatedByTrigger?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let triggerFrequency : String?
    let bpmnTriggerType : String?
    let emailTemplate : EmailTemplateTrigger?
    let triggerTime : Int?
    let scheduledDateTime : String?
    let orderOfCondition : Int?
    let actionIndex : Int?
    let addNew : Bool?
    let showBorder : Bool?
    let triggerTarget : String?
    let dateType : String?
    let timerType : String?
    let startTime : String?
    let endTime : String?
}

struct BpmnSMSTrigger : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByTrigger?
    let updatedBy : UpdatedByTrigger?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let triggerFrequency : String?
    let bpmnTriggerType : String?
    let smsTemplate : SmsTemplateTrigger?
    let triggerTime : Int?
    let actionIndex : Int?
    let orderOfCondition : Int?
    let addNew : Bool?
    let showBorder : Bool?
    let triggerTarget : String?
    let dateType : String?
    let scheduledDateTime : String?
    let timerType : String?
    let startTime : String?
    let endTime : String?
}

struct CreatedByTrigger : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct UpdatedByTrigger : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct SmsTemplateTrigger : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByTrigger?
    let updatedBy : UpdatedByTrigger?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultSmsTemplateId : Int?
    let name : String?
    let body : String?
    let subject : String?
    let smsTemplateName : String?
    let templateFor : String?
    let smsTarget : String?
    let defaultSmsTemplate : Bool?
    let active : Bool?
    let isCustom : String?
    let isCloneTemplate : String?
}
