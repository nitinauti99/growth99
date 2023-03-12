//
//  CreateSMSTemplateModel.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation

struct CreateSMSTemplateModel: Codable {
    let createdAt: String?
    let updatedBy: UpdatedBy?
    let updatedAt: String?
    let deleted: Bool?
    let id: Int?
    let smsTemplateName: String?
    let variable: String?
    let label: String?
}

