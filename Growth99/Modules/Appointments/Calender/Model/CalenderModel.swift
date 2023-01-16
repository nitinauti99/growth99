//
//  CalenderModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 16/01/23.
//

import Foundation

struct ProviderListModel: Codable {
    let userDTOList: [UserDTOList]?
}

struct UserDTOList: Codable, Equatable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let profileImageUrl: String?
    let email: String?
    let phone: String?
    let designation: String?
    let description: String?
    let provider: String?
}

struct CalenderInfoListModel: Codable {
    let appointmentDTOList: [AppointmentDTOList]?
}

struct AppointmentDTOList: Codable, Equatable {
    let id: Int?
    let patientId: Int?
    let patientFirstName: String?
    let patientLastName: String?
    let patientPhone: String?
    let patientEmail: String?
    let patientNotes: String?
    let clinicId: Int?
    let clinicName: String?
    let timeZone: String?
    let serviceList: [ServiceList]?
    let providerId: Int?
    let providerName: String?
    let paymentStatus: String?
    let appointmentStatus: String?
    let appointmentType: String?
    let appointmentStartDate: String?
    let appointmentEndDate: String?
    let appointmentCreatedDate: String?
    let appointmentUpdatedDate: String?
    let notes: String?
    let source: String?
    let paymentSource: String?
    let defaultClinic: Bool?
}
