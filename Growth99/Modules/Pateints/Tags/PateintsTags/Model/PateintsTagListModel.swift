//
//  PateintsTagListModel.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation
struct PateintsTagListModel: Codable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
}

struct PateintsTagRemove:  Codable {
    let success: String?
}
