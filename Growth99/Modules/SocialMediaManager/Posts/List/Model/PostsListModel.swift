//
//  PostsModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

struct PostsListModel: Codable {
    let scheduledDate: String?
    let label: String?
    let sent: Bool?
    let approvedDate: String?
    let createdAt: String?
    let approved: Bool?
    let post: String?
    let createdBy: String?
    let tenantId: Int?
    let name: String?
    let id: Int?
    let hashtag: String?
    let totalCount: Int?
    let postLabels: [PostLabels]?
}

struct PostLabels: Codable {
    let name: String?
    let id: Int?
}
