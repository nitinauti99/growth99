//
//  CombineTimeLineModel.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation

struct CombineTimeLineCreationModel: Codable, Equatable {
    let lastName: String?
    let firstName: String?
    let createdAt: String?
}

struct CombineTimeLineModel: Codable {
    let email: String?
    let phoneNumber: String?
    let createdDateTime: String?
    let contentId: Int?
    let name: String?
    let id: Int?
    let type: String?
}
