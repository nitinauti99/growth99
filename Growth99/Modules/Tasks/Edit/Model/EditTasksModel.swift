//
//  EditTasksModel.swift
//  Growth99
//
//  Created by nitin auti on 15/01/23.
//

import Foundation

struct EditTasksModel: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let userName: String?
    let deadLine: String?
    let userId: Int?
    let leadDTO: LeadDTODetail?
    let createdAt: String?
    let patientName: String?
    let patientId: Int?
    let patientDTO: PatientDTODetail?
    let leadId: Int?
    let status: String?
}

struct PatientDTODetail: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let email: String?
    let gender: String?
    let createdAt: String?
    let name: String?
}

struct LeadDTODetail: Codable {
    let phoneNumber : String?
    let gender : String?
    let firstName : String?
    let symptom : String?
    let message : String?
    let email : String?
    let createdAt : String?
    let lastName : String?
    let id : Int?
}
