//
//  PatientsAppointmentListModel.swift
//  Growth99
//
//  Created by nitin auti on 04/02/23.
//

import Foundation
struct PatientsAppointmentListModel: Codable {
    let patientName : String?
    let appointmentType : String?
    let createdAt : String?
    let ClinicName : String?
    let id : Int?
    let service: [PateintsService]?
    let appointmentConfirmationStatus: String?
    let source : String?
    let appointmentDate : String?
    let paymentStatus : String?
    let providerName : String?
}

struct PateintsService: Codable {
    let serviceId: Int?
    let serviceName: String?
}

//let lastName : String?
//let country : String?
//let notes : String?
//let gender : String?
//let city : String?
//let dateOfBirth : String?
//let zipcode : String?
//let firstName : String?
//let phone : String?
//let addressLine1 : String?
//let addressLine2 : String?
//let id : Int?
//let state : String?
//let patientTags : [String]?
//let email: String?
//let patientStatus: String?
