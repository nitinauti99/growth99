//
//  PateintsTimeLineModel.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation

struct PateintsTimeLineModel: Codable {
    let email: String?
    let phoneNumber: String?
    let createdDateTime: String?
    let contentId: Int?
    let name: String?
    let id: Int?
    let type: String?
}

struct PateintsTimeLineViewTemplateModel: Codable {
    let appointmentAuditContent: String?
}
