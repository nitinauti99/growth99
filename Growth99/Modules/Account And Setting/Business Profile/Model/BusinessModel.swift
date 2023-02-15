//
//  BusinessModel.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation

struct BusinessModel: Codable {
    let createdAt: String?
    let updatedAt: String?
    let createdBy: CreatedBy?
    let updatedBy: UpdatedBy?
    let deleted: Bool?
    let id: Int?
    let name: String?
    let logoUrl: String?
    let deleteBusiness: Bool?
}


