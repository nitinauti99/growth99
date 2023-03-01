//
//  DisplayQuestionariModel.swift
//  Growth99
//
//  Created by Nitin Auti on 01/03/23.
//

import Foundation


struct DisplayQuestionnaireModel: Codable{
    let id : Int?
    let showLogo : Int?
    let questionnaireName: String?
    let patientQuestionAnswers: [PatientQuestionAnswers]?
}

struct PatientQuestionAnswers:Codable {
    let id : Int?
    let questionId : Int?
    let questionName : String?
    let questionType : String?
    let validationMessage : String?
    let answerText : String?
}
