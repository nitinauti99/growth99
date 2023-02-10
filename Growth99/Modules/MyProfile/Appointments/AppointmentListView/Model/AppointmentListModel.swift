//
//  AppointmentListModel.swift
//  Growth99
//
//  Created by Sravan Goud on 05/02/23.
//

import Foundation

struct AppointmentListModel: Codable {
    let clinicName: String?
    let appointmentType: String?
    let clinicId: Int?
    let patientId: Int?
    let patientFirstname: String?
    let appointmentConfirmationStatus: String?
    let source: String?
    let patientLastName: String?
    let createdAt: String?
    let providerId: Int?
    let id: Int?
    let appointmentDate: String?
    let providerName: String?
    let paymentStatus: String?
}
