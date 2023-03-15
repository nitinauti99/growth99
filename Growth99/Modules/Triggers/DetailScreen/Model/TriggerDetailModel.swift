//
//  TriggerDetailModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation

struct TriggerDetailModel: Codable {
    let cellType: String?
    let LastName: String?
}

struct TriggerDetailListModel : Codable {
    let userDTOList : [UserDTOListTrigger]?
    let smsTemplateDTOList : [SmsTemplateDTOListTrigger]?
    let emailTemplateDTOList : [EmailTemplateDTOListTrigger]?
}

struct EmailTemplateDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let emailTarget : String?
    let templateFor : String?
}

struct SmsTemplateDTOListTrigger : Codable, Equatable {
    let id : Int?
    let name : String?
    let smsTarget : String?
    let templateFor : String?
}

struct UserDTOListTrigger : Codable, Equatable {
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

struct TriggerTagListModel: Codable, Equatable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
}

struct TriggerCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
}

struct TriggerEQuotaCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
    let tenantId : Int?
}

struct TriggerQuestionnaireModel : Codable, Equatable {
    let name : String?
    let id : Int?
}

struct TriggerCreateModel : Codable {
    let name : String?
    let moduleName : String?
    let triggeractionName : String?
    let triggerConditions : [String]?
    let triggerData : [TriggerCreateData]?
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

struct TriggerCreateData : Codable {
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
        return dictionary
    }
}

struct TriggerCreateSourceUrls : Codable {
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

struct LandingPageNamesModel : Codable, Equatable {
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
