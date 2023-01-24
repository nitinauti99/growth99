//
//  QuestionarieModel.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import Foundation

struct QuestionarieListModel: Codable {
    let name: String?
    let noOfQuestions: Int?
    let isG99ReviewForm: Bool?
    let updatedBy: String?
    let createdBy: String?
    let id: Int?
}
