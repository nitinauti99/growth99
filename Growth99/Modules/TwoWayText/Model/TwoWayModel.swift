//
//  TwoWayModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/12/23.
//

import Foundation

struct TwoWayModel : Codable {
    let pageNumber : Int?
    let pageSize : Int?
    let totalNumberOfElements : Int?
    let auditLogsList : [AuditLogsList]?
}

struct AuditLogs : Codable {
    let id : Int?
    let sourceId : Int?
    let sourceType : String?
    let sourceName : String?
    let businessId : Int?
    let senderNumber : String?
    let receiverNumber : String?
    let forwardedNumber : String?
    let direction : String?
    let message : String?
    let createdDateTime : String?
    let smsRead : Bool?
    let deliverStatus : String?
    let errorMessage : String?
}

struct AuditLogsList : Codable {
    let sourceId : Int?
    let auditLogs : [AuditLogs]?
    let leadStatus : String?
    let lastMessageDate : String?
    let leadChatStatus : String?
    let lastMessageRead : Bool?
    let sourcePhoneNumber : String?
    let source : String?
    let sourceName : String?
    let communication : String?
    let leadFullName : String?
}
