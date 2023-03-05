//
//  TriggersListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct MassEmailandSMSModel : Codable {
    let bpmnTasks : [String]?
    let bpmnEmails : [BpmnEmails]?
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
    let bpmnSMS : [BpmnSMS]?
    let updatedAt : String?
    let status : String?
}

struct BpmnSMS : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByEmail?
    let updatedBy : UpdatedByEmail?
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

struct SmsTemplate : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByEmail?
    let updatedBy : UpdatedByEmail?
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
    let isCloneTemplate : Bool?
}

struct BpmnEmails : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByEmail?
    let updatedBy : UpdatedByEmail?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let triggerFrequency : String?
    let bpmnTriggerType : String?
    let emailTemplate : EmailSMSTemplate?
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

struct EmailSMSTemplate : Codable {
    let templateFor : String?
    let active : Bool?
    let deleted : Bool?
    let subject : String?
    let createdAt : String?
    let emailTarget : String?
    let name : String?
    let defaultEmailTemplateId : Int?
    let updatedAt : String?
    let body : String?
    let createdBy : CreatedByEmail?
    let tenantId : Int?
    let id : Int?
    let questionnaire : String?
    let defaultEmailTemplate : Bool?
    let identifier : String?
    let updatedBy : UpdatedByEmail?
    let isCustom : String?
    let emailTemplateName : String?
    let isCloneTemplate : String?
}

struct CreatedByEmail : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct UpdatedByEmail : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}
