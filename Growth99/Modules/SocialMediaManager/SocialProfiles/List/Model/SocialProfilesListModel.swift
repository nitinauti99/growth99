//
//  SocialProfilesModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

struct SocialProfilesListModel: Codable {
    let name: String?
    let socialChannel: String?
    let id: Int?
}

struct SocialProfilesListRemove: Codable {
    let success: String?
}
