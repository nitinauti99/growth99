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
    let leadTags : [MassEmailSMSTagListModelEdit]?
    let isTriggerForLeadStatus : Bool?
    let fromLeadStatus : String?
    let toLeadStatus : String?
    
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
        if leadTags != nil {
            var arrOfDict = [[String: Any]]()
            for item in leadTags! {
                arrOfDict.append(item.toDict())
            }
            dictionary["leadTags"] = arrOfDict
        }
        if isTriggerForLeadStatus != nil {
            dictionary["isTriggerForLeadStatus"] = isTriggerForLeadStatus
        }
        if fromLeadStatus != nil {
            dictionary["fromLeadStatus"] = fromLeadStatus
        }
        if toLeadStatus != nil {
            dictionary["toLeadStatus"] = toLeadStatus
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
    let leadTags : [MassEmailSMSTagListModelEdit]?
    let isTriggerForLeadStatus : Bool?
    let fromLeadStatus : String?
    let toLeadStatus : String?

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
        if leadTags != nil {
            var arrOfDict = [[String: Any]]()
            for item in leadTags! {
                arrOfDict.append(item.toDict())
            }
            dictionary["leadTags"] = arrOfDict
        }
        if isTriggerForLeadStatus != nil {
            dictionary["isTriggerForLeadStatus"] = isTriggerForLeadStatus
        }
        if fromLeadStatus != nil {
            dictionary["fromLeadStatus"] = fromLeadStatus
        }
        if toLeadStatus != nil {
            dictionary["toLeadStatus"] = toLeadStatus
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
    let triggerTime : Int?
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
    let triggerTime : Int?
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
    let sourceUrls : [Int]?
    let patientTags : [Int]?
    let triggerConditions : [String]?
    let forms : [Int]?
    let isTriggerForLeadStatus : Bool?
    let toLeadStatus : String?
    let triggerData : [TriggerEditData]?
    let landingPages : [Int]?
    let moduleName : String?
    let source : String?
    let executionStatus : String?
    let patientStatus : String?
    let fromLeadStatus : String?
    let leadTags : [Int]?
    let triggerActionName : String?
    let name : String?
}

struct TriggerEditData : Codable, Equatable {
    let id : String?
    let timerType : String?
    let triggerTarget : String?
    let triggerFrequency : String?
    let actionIndex : Int?
    let dateType : String?
    let triggerTime : Int?
    let showBorder : Bool?
    let userId : String?
    let scheduledDateTime : String?
    let triggerTemplate : Int?
    let addNew : Bool?
    let endTime : String?
    let triggerType : String?
    let taskName : String?
    let startTime : String?
    let orderOfCondition : Int?
    let type: String?
    
    init(id: String?, timerType: String?, triggerTarget: String?, triggerFrequency: String?, actionIndex: Int?, dateType: String?, triggerTime: Int?, showBorder: Bool?, userId: String?, scheduledDateTime: String?, triggerTemplate: Int?, addNew: Bool?, endTime: String?, triggerType: String?, taskName: String?, startTime: String?, orderOfCondition: Int?, type: String?) {
        self.id = id
        self.timerType = timerType
        self.triggerTarget = triggerTarget
        self.triggerFrequency = triggerFrequency
        self.actionIndex = actionIndex
        self.dateType = dateType
        self.triggerTime = triggerTime
        self.showBorder = showBorder
        self.userId = userId
        self.scheduledDateTime = scheduledDateTime
        self.triggerTemplate = triggerTemplate
        self.addNew = addNew
        self.endTime = endTime
        self.triggerType = triggerType
        self.taskName = taskName
        self.startTime = startTime
        self.orderOfCondition = orderOfCondition
        self.type = type
    }
}

