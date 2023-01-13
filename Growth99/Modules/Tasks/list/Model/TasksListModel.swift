//
//  TasksListModel.swift
//  Growth99
//
//  Created by nitin auti on 09/01/23.
//

import Foundation

struct TasksListModel: Codable {
    let taskDTOList: [TaskDTOList]
}

struct TaskDTOList: Codable {
        let id: Int?
        let name: String?
        let description: String?
        let userName: String?
        let deadLine: String?
        let userId: Int?
        let leadDTO: String?
        let createdAt: String?
        let patientName: String?
        let patientId: Int?
        let patientDTO: PatientDTO?
        let leadId: Int?
}

struct PatientDTO: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let email: String?
    let gender: String?
    let createdAt: String?
}
