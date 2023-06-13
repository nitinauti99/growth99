//
//  FormDetailModel.swift
//  Growth99
//
//  Created by Nitin Auti on 15/02/23.
//

import Foundation
struct FormDetailModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let type : String?
    let answer : String?
    let required : Bool?
    let questionOrder : Int?
    let allowMultipleSelection : Bool?
    let allowLabelsDisplayWithImages : Bool?
    let hidden : Bool?
    let validate : Bool?
    let regex : String?
    let validationMessage : String?
    let showDropDown : Bool?
    let preSelectCheckbox : Bool?
    let description : String?
    let subHeading : String?
    let questionChoices : [QuestionChoices]?
    let questionImages : [String]?
    let isLeadForm: Bool?

    
    init(createdAt: String?, updatedAt: String?, createdBy: CreatedBy?, updatedBy: UpdatedBy?, deleted: Bool?, tenantId: Int?, id: Int?, name: String?, type: String?, answer: String?, required: Bool?, questionOrder: Int?, allowMultipleSelection: Bool?, allowLabelsDisplayWithImages: Bool?, hidden: Bool?, validate: Bool?, regex: String?, validationMessage: String?, showDropDown: Bool?, preSelectCheckbox: Bool?, description: String?, subHeading: String?, questionChoices: [QuestionChoices]?, questionImages: [String]?,isLeadForm: Bool?) {
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.createdBy = createdBy
        self.updatedBy = updatedBy
        self.deleted = deleted
        self.tenantId = tenantId
        self.id = id
        self.name = name
        self.type = type
        self.answer = answer
        self.required = required
        self.questionOrder = questionOrder
        self.allowMultipleSelection = allowMultipleSelection
        self.allowLabelsDisplayWithImages = allowLabelsDisplayWithImages
        self.hidden = hidden
        self.validate = validate
        self.regex = regex
        self.validationMessage = validationMessage
        self.showDropDown = showDropDown
        self.preSelectCheckbox = preSelectCheckbox
        self.description = description
        self.subHeading = subHeading
        self.questionChoices = questionChoices
        self.questionImages = questionImages
        self.isLeadForm = isLeadForm
    }
}

struct QuestionChoices: Codable {
    let deleted : Bool?
    let id : Int?
    let tenantId : Int?
    let updatedBy : UpdatedBy?
    let updatedAt : String?
    let createdAt : String?
    let createdBy : CreatedBy?
    let name : String?
   
    init(deleted: Bool?, id: Int?, tenantId: Int?, updatedBy: UpdatedBy?, updatedAt: String?, createdAt: String?, createdBy: CreatedBy?, name: String?) {
        self.deleted = deleted
        self.id = id
        self.tenantId = tenantId
        self.updatedBy = updatedBy
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.name = name
    }
}

struct QuestionFormDetailModel : Codable {
    let name : String?
    let type : String?
    let required : Bool?
    let hidden : Bool?
    let validate : Bool?
    let regex : String?
    let questionOrder : Int?
    let answer : String?
    let id : Int?
    let allowLabelsDisplayWithImages : Bool?
    let allowMultipleSelection : Bool?
    let questionChoices : [QuestionChoices]?
    let questionImages : [String]?
    let validationMessage : String?

    init(name: String?, type: String?, required: Bool?, hidden: Bool?, validate: Bool?, regex: String?, questionOrder: Int?, answer: String?, id: Int?, allowLabelsDisplayWithImages: Bool?, allowMultipleSelection: Bool?, questionChoices: [QuestionChoices]?, questionImages: [String]?, validationMessage: String?) {
        self.name = name
        self.type = type
        self.required = required
        self.hidden = hidden
        self.validate = validate
        self.regex = regex
        self.questionOrder = questionOrder
        self.answer = answer
        self.id = id
        self.allowLabelsDisplayWithImages = allowLabelsDisplayWithImages
        self.allowMultipleSelection = allowMultipleSelection
        self.questionChoices = questionChoices
        self.questionImages = questionImages
        self.validationMessage = validationMessage
    }
    
}

struct RegexList: Codable, Equatable {
    var regexArray: [String] = [
        "Email",
        "Phone",
        "Name including space",
        "Name without space",
        "User name contain special character without space",
        "Date validation dd/MM/yyyy or dd-MM-yyyy",
        "Date validation MM/dd/yyyy or MM-dd-yyyy",
        "Date validation yyyy/MM/dd or yyyy-MM-dd"
    ]
}
