//
//  CategoriesListModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

struct CategoriesListModel: Codable {
    let createdAt: String?
    let updatedBy: String?
    let createdBy: String?
    let name: String?
    let tenantId: Int?
    let id: Int?
    let updatedAt: String?
}

struct CategoriesAddEditModel: Codable {
    let createdAt: String?
    let updatedAt: String?
    let createdBy: CreatedBy?
    let updatedBy: UpdatedBy?
    let deleted: Bool?
    let tenantId: Int?
    let id: Int?
    let clinics : [ClinicsServices]?
    let name: String?
    let isDefault: Bool?
    let defaultServiceCategoryId: String?
    let specialization: String?
}
