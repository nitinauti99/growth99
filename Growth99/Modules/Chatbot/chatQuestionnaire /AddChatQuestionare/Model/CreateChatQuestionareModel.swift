//
//  CreateChatQuestionareModel.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import Foundation

struct ChatQuestionareModel: Codable {
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

struct ChatQuestionareListModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let question : String?
    let answer : String?
    let referenceLink : String?
    let chatQuestionnaire : ChatQuestionnaire?
}

struct ChatQuestionnaire : Codable {
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

