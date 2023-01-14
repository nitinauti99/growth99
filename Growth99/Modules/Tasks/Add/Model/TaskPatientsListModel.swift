//
//  TaskPatientsListModel.swift
//  Growth99
//
//  Created by nitin auti on 13/01/23.
//

import Foundation

struct TaskPatientsListModel: Codable , Equatable{
    let firstName: String?
    let lastName: String?
    let createdAt: String?
    let name: String?
    let updatedBy: String?
    let createdBy: String?
    let id: Int?
    let email: String?
    let patientStatus: String?
    let updatedAt: String?
}
