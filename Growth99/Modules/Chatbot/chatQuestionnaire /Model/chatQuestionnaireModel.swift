//
//  chatQuestionnaireModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

struct chatQuestionnaireModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let questionnaireSource : String?
}
