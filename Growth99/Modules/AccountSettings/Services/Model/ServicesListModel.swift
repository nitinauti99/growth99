//
//  ServicesListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct ServiceListModel: Codable {
    let serviceList: [ServiceList]?
}

struct ServiceList: Codable, Equatable {
    let createdAt: String?
    let updatedBy: String?
    let createdBy: String?
    let name: String?
    let id: Int?
    let position: Int?
    let serviceId: Int?
    let serviceName: String?
    let categoryName: String?
    let categoryId: Int?
    let updatedAt: String?
}

struct ConsentListModel: Codable, Equatable {
    let createdAt: String?
    let updatedBy: String?
    let createdBy: String?
    let name: String?
    let id: Int?
    let updatedAt: String?
}

struct QuestionnaireListModel: Codable, Equatable {
    let createdAt: String?
    let updatedBy: String?
    let noOfQuestions: Int?
    let isContactForm: Bool?
    let createdBy: String?
    let name: String?
    let id: Int?
    let isG99ReviewForm: Bool?
    let updatedAt: String?
}

struct ServiceDetailModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let durationInMinutes : Int?
    let serviceCost : Double?
    let serviceURL : String?
    let description : String?
    let imageUrl : String?
    let isDefault : Bool?
    let defaultServiceId : Int?
    let position : Int?
    let serviceCategory : ServiceCategory?
    let clinics : [ClinicsServices]?
    let consents : [Consents]?
    let questionnaires : [Questionnaires]?
    let preBookingCost : Double?
    let isPreBookingCostAllowed : Bool?
    let showInPublicBooking : Bool?
    let priceVaries : Bool?
    let serviceName : String?
    let serviceId : String?
}

struct ClinicsServices : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let clinic : Clinic?
}
