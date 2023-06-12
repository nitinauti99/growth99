//
//  ConsentsModel.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import Foundation

struct AddNewConsentsModel: Codable {
    let name: String?
    let noOfQuestions: Int?
    let isG99ReviewForm: Bool?
    let updatedBy: String?
    let createdBy: String?
    let id: Int?
}

struct CreateNewConsentsModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let appointment : String?
    let patient : Patient?
    let appointmentBookedService : String?
    let consent : Consent?
    let appointmentConsentStatus : String?
    let signedDate : String?
    let declinedDate : String?
    let signFileGenerated : Bool?
}

struct Consent : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let defaultConsentId : Int?
    let name : String?
    let body : String?
    let isDefault : Bool?
    let tag : String?
    let isCustom : String?
    let specialization : String?
    let generic : Bool?
    let specializationId : String?
    let serviceId : String?
    let serviceIds : String?
}
