//
//  QuestionnaireList.swift
//  Growth99
//
//  Created by nitin auti on 16/12/22.
//

import Foundation

struct QuestionnaireList: Codable {
    let id: Int?
    let questionnaireId: Int?
    let source: String?
    let patientQuestionAnswers: [PatientQuestionAnswersList]?
}

struct PatientQuestionAnswersList: Codable {
    let questionId: Int?
    let questionName: String?
    let questionType: String?
    let allowMultipleSelection: Bool?
    let preSelectCheckbox: Bool?
    var answer: Bool?
    var answerText: String?
    let answerComments: String?
    let patientQuestionChoices: [PatientQuestionChoices]?
    let required: Bool?
    let hidden: Bool?
    let showDropDown: Bool?
    let regex: String?
    let validationMessage: String?
}

struct PatientQuestionChoices: Codable, Equatable {
    let choiceName: String?
    let choiceId: Int?
    var selected: Bool?
    let id: Int?
}
