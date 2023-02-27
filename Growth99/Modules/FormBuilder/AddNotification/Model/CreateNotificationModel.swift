//
//  CreateNotificationModel.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

import Foundation

struct CreateNotificationModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let questionnaireId : Int?
    let notificationType : String?
    let toEmail : String?
    let phoneNumber : String?
    let messageText : String?
}
