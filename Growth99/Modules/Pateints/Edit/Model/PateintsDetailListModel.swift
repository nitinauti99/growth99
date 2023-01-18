//
//  PateintsDetailListModel.swift
//  Growth99
//
//  Created by nitin auti on 05/01/23.
//

import Foundation

struct PateintsDetailListModel: Codable{
    let firstName: String?
    let lastName: String?
    let createdAt: String?
    let updatedBy: String?
    let phone: String?
    let id: Int?
    let createdBy: String?
    let email: String?
    let name: String?
    let patientStatus: String?
    let updatedAt: String?
    let dateOfBirth: String?
    let zipcode: String?
    let addressLine1: String?
    let addressLine2: String?
    let state: String?
    let gender: String?
    let tag: [Tag]?
}

struct Tag:Codable {
    let name: String?
    let id: Int?
}
