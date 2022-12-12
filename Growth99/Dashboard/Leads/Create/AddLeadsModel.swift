//
//  AddLeadsModel.swift
//  Growth99
//
//  Created by nitin auti on 10/12/22.
//

import Foundation

struct AddLeadsModel: Codable {
    let id: String?
    let questionnaireId: Int?
    let source: String?
    let patientQuestionAnswers: [PatientQuestionAnswers]?
    
    func toDict() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil {
            dictionary["id"] = id
        }
        if questionnaireId != nil {
            dictionary["questionnaireId"] = questionnaireId
        }
        if source != nil {
            dictionary["source"] = source
        }
        if patientQuestionAnswers != nil {
            var arrOfDict = [[String: Any]]()
            for item in patientQuestionAnswers! {
                //arrOfDict.append(item.toDict())
            }
            dictionary["patientQuestionAnswers"] = arrOfDict
        }
        return dictionary
    }

}

struct PatientQuestionAnswers: Codable {
    let questionId: Int?
    let questionName: String?
    let questionType: String?
    let allowMultipleSelection: Bool?
    let preSelectCheckbox: Bool?
    let answer: String?
    let answerText: String?
    let answerComments: String?
    let patientQuestionChoices: [String]?
    let required: Bool?
    let hidden: Bool?
    let showDropDown: Bool?
}
