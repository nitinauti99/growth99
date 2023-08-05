//
//  AuditListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct AuditListModel : Codable {
    let date : String?
    let templateName : String?
    let patientId : Int?
    let contentId : Int?
    let label : String?
    let email : String?
    let leadId : Int?
    let phoneNumber : String?
}
