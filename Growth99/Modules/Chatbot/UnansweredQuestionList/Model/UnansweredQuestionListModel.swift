//
//  UnansweredQuestionListModel.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation

struct UnansweredQuestionListModel:Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let chatSession : String?
    let question : String?
}
