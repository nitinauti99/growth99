//
//  ServicesListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct ServicesListModel: Codable {
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
