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

struct ServiceList: Codable {
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
