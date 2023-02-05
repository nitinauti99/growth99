//
//  ConsentsModel.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import Foundation

struct AddNewConsentsModel: Codable {
    let name: String?
    let noOfQuestions: Int?
    let isG99ReviewForm: Bool?
    let updatedBy: String?
    let createdBy: String?
    let id: Int?
}
