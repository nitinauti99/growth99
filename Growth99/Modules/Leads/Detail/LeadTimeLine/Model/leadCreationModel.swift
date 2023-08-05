//
//  leadCreationModel.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation

struct leadCreationModel: Codable, Equatable {
    let lastName: String?
    let firstName: String?
    let createdAt: String?
}

struct auditLeadModel: Codable {
    let email: String?
    let phoneNumber: String?
    let createdDateTime: String?
    let contentId: Int?
    let name: String?
    let id: Int?
    let type: String?
}

struct LeadTimeLineViewTemplateModel: Codable {
    let leadAuditContent: String?
}

struct AppointmentTimeLineViewTemplateModel: Codable {
    let appointmentAuditContent: String?
}

