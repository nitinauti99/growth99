//
//  QuestionnaireDetailList.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import Foundation

struct QuestionnaireDetailList: Codable {
    let id: Int?
    let questionnaireId: Int?
    let source: String?
    let leadStatus: String?
    let questionnaireName: String?
    let questionAnswers: [QuestionAnswers]?
}

struct QuestionAnswers: Codable, Equatable {
    let questionId: Int?
    let questionName: String?
    let questionType: String?
    let allowMultipleSelection: Bool?
    let preSelectCheckbox: Bool?
    var answer: String?
    var answerText: String?
    let answerComments: String?
    let required: Bool?
    let hidden: Bool?
    let showDropDown: Bool?
    let regex: String?
    let validationMessage: String?
}
