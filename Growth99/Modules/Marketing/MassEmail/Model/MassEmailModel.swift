//
//  BookingHistoryModel.swift
//  Growth99
//
//  Created by Mahender Reddy on 31/01/23.
//

import Foundation

struct MassEmailSMSModel : Codable {
    let bpmnTasks : [String]?
    let bpmnEmails : [String]?
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
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let triggerFrequency : String?
    let bpmnTriggerType : String?
    let smsTemplate : SmsTemplate?
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
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultSmsTemplateId : String?
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
