//
//  LeadTagsModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
struct LeadTagListModel: Codable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
}

struct LeadTagRemove:  Codable {
    let success: String?
}
