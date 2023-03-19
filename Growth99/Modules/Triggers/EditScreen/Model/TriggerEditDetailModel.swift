//
//  TriggerEditDetailModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation

struct TriggerEditDetailModel: Codable {
    let cellType: String?
    let LastName: String?
}

struct TriggerEditDetailListModel : Codable {
    let userDTOList : [UserDTOListEditTrigger]?
    let smsTemplateDTOList : [SmsTemplateEditDTOListTrigger]?
    let emailTemplateDTOList : [EmailEditTemplateDTOListTrigger]?
}

struct EmailEditTemplateDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let emailTarget : String?
    let templateFor : String?
}

struct SmsTemplateEditDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let smsTarget : String?
    let templateFor : String?
}

struct UserDTOListEditTrigger : Codable, Equatable {
    let gender : String?
    let phone : String?
    let firstName : String?
    let id : Int?
    let provider : String?
    let profileImageUrl : String?
    let email : String?
    let designation : String?
    let description : String?
    let lastName : String?
}

struct TriggerEditTagListModel: Codable, Equatable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
}

struct TriggerEditCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
}

struct TriggerEditEQuotaCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
    let tenantId : Int?
}

struct TriggerEditQuestionnaireModel : Codable, Equatable {
    let name : String?
    let id : Int?
}

struct TriggerEditCreateModel : Codable {
    let name : String?
    let moduleName : String?
    let triggeractionName : String?
    let triggerConditions : [String]?
    let triggerData : [TriggerEditCreateData]?
    let landingPageNames : [EditLandingPageNamesModel]?
    let forms : [EditLandingPageNamesModel]?
    let sourceUrls : [TriggerEditCreateSourceUrls]?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if name != nil {
            dictionary["name"] = name
        }
        if moduleName != nil {
            dictionary["moduleName"] = moduleName
        }
        if triggeractionName != nil {
            dictionary["triggeractionName"] = triggeractionName
        }
        if triggerConditions != nil {
            dictionary["triggerConditions"] = triggerConditions
        }
        
        if triggerData != nil {
            var arrOfDict = [[String: Any]]()
            for item in triggerData! {
                arrOfDict.append(item.toDict())
            }
            dictionary["triggerData"] = arrOfDict
        }
        
        if landingPageNames != nil {
            var arrOfDict = [[String: Any]]()
            for item in landingPageNames! {
                arrOfDict.append(item.toDict())
            }
            dictionary["landingPageNames"] = arrOfDict
        }
        if forms != nil {
            var arrOfDict = [[String: Any]]()
            for item in forms! {
                arrOfDict.append(item.toDict())
            }
            dictionary["forms"] = arrOfDict
        }
        if sourceUrls != nil {
            var arrOfDict = [[String: Any]]()
            for item in sourceUrls! {
                arrOfDict.append(item.toDict())
            }
            dictionary["sourceUrls"] = arrOfDict
        }
        return dictionary
    }
}

struct TriggerEditAppointmentCreateModel : Codable {
    let name : String?
    let moduleName : String?
    let triggeractionName : String?
    let triggerConditions : [String]?
    let triggerData : [TriggerEditAppointmentCreateData]?
    let landingPageNames : [LandingPageNamesModel]?
    let forms : [LandingPageNamesModel]?
    let sourceUrls : [TriggerCreateSourceUrls]?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if name != nil {
            dictionary["name"] = name
        }
        if moduleName != nil {
            dictionary["moduleName"] = moduleName
        }
        if triggeractionName != nil {
            dictionary["triggeractionName"] = triggeractionName
        }
        if triggerConditions != nil {
            dictionary["triggerConditions"] = triggerConditions
        }
        
        if triggerData != nil {
            var arrOfDict = [[String: Any]]()
            for item in triggerData! {
                arrOfDict.append(item.toDict())
            }
            dictionary["triggerData"] = arrOfDict
        }
        
        if landingPageNames != nil {
            var arrOfDict = [[String: Any]]()
            for item in landingPageNames! {
                arrOfDict.append(item.toDict())
            }
            dictionary["landingPageNames"] = arrOfDict
        }
        if forms != nil {
            var arrOfDict = [[String: Any]]()
            for item in forms! {
                arrOfDict.append(item.toDict())
            }
            dictionary["forms"] = arrOfDict
        }
        if sourceUrls != nil {
            var arrOfDict = [[String: Any]]()
            for item in sourceUrls! {
                arrOfDict.append(item.toDict())
            }
            dictionary["sourceUrls"] = arrOfDict
        }
        return dictionary
    }
}

struct TriggerEditAppointmentCreateData : Codable {
    let actionIndex : Int?
    let addNew : Bool?
    let triggerTemplate : Int?
    let triggerType : String?
    let triggerTarget : String?
    let triggerTime : String?
    let triggerFrequency : String?
    let taskName : String?
    let showBorder : Bool?
    let orderOfCondition : Int?
    let dateType : String?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if actionIndex != nil {
            dictionary["actionIndex"] = actionIndex
        }
        if addNew != nil {
            dictionary["addNew"] = addNew
        }
        if triggerTemplate != nil {
            dictionary["triggerTemplate"] = triggerTemplate
        }
        if triggerType != nil {
            dictionary["triggerType"] = triggerType
        }
        if triggerTarget != nil {
            dictionary["triggerTarget"] = triggerTarget
        }
        if triggerTime != nil {
            dictionary["triggerTime"] = triggerTime
        }
        if triggerFrequency != nil {
            dictionary["triggerFrequency"] = triggerFrequency
        }
        if taskName != nil {
            dictionary["taskName"] = taskName
        }
        if showBorder != nil {
            dictionary["showBorder"] = showBorder
        }
        if orderOfCondition != nil {
            dictionary["orderOfCondition"] = orderOfCondition
        }
        if dateType != nil {
            dictionary["dateType"] = dateType
        }
        return dictionary
    }
}

struct TriggerEditCreateData : Codable {
    let actionIndex : Int?
    let addNew : Bool?
    let triggerTemplate : Int?
    let triggerType : String?
    let triggerTarget : String?
    let triggerTime : String?
    let triggerFrequency : String?
    let taskName : String?
    let showBorder : Bool?
    let orderOfCondition : Int?
    let dateType : String?
    let timerType : String?
    let startTime : String?
    let endTime : String?
    let deadline: String?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if actionIndex != nil {
            dictionary["actionIndex"] = actionIndex
        }
        if addNew != nil {
            dictionary["addNew"] = addNew
        }
        if triggerTemplate != nil {
            dictionary["triggerTemplate"] = triggerTemplate
        }
        if triggerType != nil {
            dictionary["triggerType"] = triggerType
        }
        if triggerTarget != nil {
            dictionary["triggerTarget"] = triggerTarget
        }
        if triggerTime != nil {
            dictionary["triggerTime"] = triggerTime
        }
        if triggerFrequency != nil {
            dictionary["triggerFrequency"] = triggerFrequency
        }
        if taskName != nil {
            dictionary["taskName"] = taskName
        }
        if showBorder != nil {
            dictionary["showBorder"] = showBorder
        }
        if orderOfCondition != nil {
            dictionary["orderOfCondition"] = orderOfCondition
        }
        if dateType != nil {
            dictionary["dateType"] = dateType
        }
        if timerType != nil {
            dictionary["timerType"] = timerType
        }
        if startTime != nil {
            dictionary["startTime"] = startTime
        }
        if endTime != nil {
            dictionary["endTime"] = endTime
        }
        if deadline != nil {
            dictionary["deadline"] = deadline
        }
        return dictionary
    }
}

struct TriggerEditCreateSourceUrls : Codable {
    let sourceUrl : String?
    let id : Int?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if sourceUrl != nil {
            dictionary["sourceUrl"] = sourceUrl
        }
        if id != nil {
            dictionary["id"] = id
        }
        return dictionary
    }
}

struct EditLandingPageNamesModel : Codable, Equatable {
    let name : String?
    let id : Int?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if name != nil {
            dictionary["name"] = name
        }
        if id != nil {
            dictionary["id"] = id
        }
        return dictionary
    }
}

struct TriggerEditModel : Codable {
    let id : Int?
    let sourceUrls : [LeadSourceUrlListModel]?
    let patientTags : String?
    let triggerConditions : [String]?
    let forms : [EditLandingPageNamesModel]?
    let triggerData : [TriggerEditData]?
    let landingPages : [EditLandingPageNamesModel]?
    let moduleName : String?
    let source : String?
    let executionStatus : String?
    let patientStatus : String?
    let leadTags : String?
    let triggerActionName : String?
    let name : String?
}

struct TriggerEditData : Codable {
    let id : String?
    let triggerType : String?
    let triggerTemplate : Int?
    let userId : String?
    let triggerTime : Int?
    let actionIndex : Int?
    let addNew : Bool?
    let showBorder : Bool?
    let taskName : String?
    let orderOfCondition : Int?
    let triggerFrequency : String?
    let triggerTarget : String?
    let dateType : String?
    let scheduledDateTime : String?
    let timerType : String?
    let startTime : String?
    let endTime : String?
}
