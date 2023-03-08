//
//  DisplayQuestionnaireqsubmissionsModel.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import Foundation

struct DisplayQuestionnaireqsubmissionsModel: Codable{
    let id : Int?
    let questionnaireId : Int?
    let questionnaireName : String?
    let source : String?
    let landingPageName : String?
    let leadStatus : String?
    let createdAt : String?
    let sourceUrl : String?
    let tag : String?
    let amount : Double?
    let questionAnswers : [QuestionAnswersModel]?
}

struct QuestionAnswersModel: Codable {
    let id : String?
    let questionId : Int?
    let questionName : String?
    let questionType : String?
    let hidden : Bool?
    let required : Bool?
    let validate : Bool?
    let regex : String?
    let validationMessage : String?
    let answer : String?
    let answerText : String?
    let answerComments : String?
    let answerOptions : String?
    let questionChoices : [FormQuestionChoices]?
    let patientQuestionChoices : String?
    let allowMultipleSelection : Bool?
    let showDropDown : Bool?
    let preSelectCheckbox : Bool?
    let subHeading : String?
    let description : String?
}

struct FormQuestionChoices: Codable, Equatable {
    let choiceName: String?
    let choiceId: Int?
    var selected: Bool?
    let id: Int?
}
