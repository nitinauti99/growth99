//
//  ConsentsListModel.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation

struct ConsentsListModel: Codable {
    let name: String?
    let appointmentId: Int?
    let appointmentConsentStatus: String?
    let appointmentDate: String?
    let createdAt: String?
    let consentId: Int?
    let signedDate: String?
    let id: Int?
    let signFileGenerated : String?
}
