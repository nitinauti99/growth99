//
//  MediaTagsListModel.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation

struct MediaTagListModel: Codable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
}

struct MediaTagRemove:  Codable {
    let success: String?
}
