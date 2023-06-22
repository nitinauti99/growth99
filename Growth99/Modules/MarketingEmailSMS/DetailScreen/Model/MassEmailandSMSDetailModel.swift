//
//  MassEmailandSMSDetailModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation

struct MassEmailandSMSDetailModel: Codable {
    let cellType: String?
    let LastName: String?
}

struct MassEmailSMSDetailListModel : Codable {
    let userDTOList : [UserDTOListEmailSMS]?
    let smsTemplateDTOList : [SmsTemplateDTOList]?
    let emailTemplateDTOList : [EmailTemplateDTOList]?
}

struct EmailTemplateDTOList : Codable, Equatable {
    let id : Int?
    let name : String?
    let emailTarget : String?
    let templateFor : String?
}

struct SmsTemplateDTOList : Codable, Equatable {
    let id : Int?
    let name : String?
    let smsTarget : String?
    let templateFor : String?
}

struct UserDTOListEmailSMS : Codable {
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

struct MassEmailSMSTagListModel: Codable, Equatable {
    let name: String?
    let isDefault: Bool?
    let id: Int?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if isDefault != nil {
            dictionary["isDefault"] = isDefault
        }
        if name != nil {
            dictionary["name"] = name
        }
        if id != nil {
            dictionary["id"] = id
        }
        return dictionary
    }
}

struct MassEmailSMSCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
}

struct MassEmailSMSEQuotaCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
    let tenantId : Int?
}

struct MarketingSMSEmailResModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedByMarketing?
    let updatedBy : UpdatedByMarketing?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let moduleName : String?
    let triggerActionName : String?
    let landingPages : [String]?
    let forms : String?
    let sourceUrls : [Int]?
    let triggerConditions : [String]?
    let source : [String]?
    let emailFlag : Bool?
    let smsFlag : Bool?
    let taskFlag : Bool?
    let defaultTrigger : String?
    let defaultTriggerId : String?
    let bpmnEmails : String?
    let bpmnSMS : String?
    let bpmnTasks : String?
    let status : String?
    let executionStatus : String?
    let isCustom : Bool?
    let leadTags : [Int]?
    let patientTags : [Int]?
    let patientStatus : String?
}

struct UpdatedByMarketing : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct CreatedByMarketing : Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct MarketingLeadModel : Codable {
    let name : String?
    let moduleName : String?
    let triggerConditions : [String]?
    let leadTags : [MassEmailSMSTagListModel]?
    let patientTags : [MassEmailSMSTagListModel]?
    let patientStatus : [String]?
    let triggerData : [MarketingTriggerData]?
    let source : [String]?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if name != nil {
            dictionary["name"] = name
        }
        if moduleName != nil {
            dictionary["moduleName"] = moduleName
        }
        if triggerConditions != nil {
            dictionary["triggerConditions"] = triggerConditions
        }
        if patientStatus != nil {
            dictionary["patientStatus"] = patientStatus
        }
        if source != nil {
            dictionary["source"] = source
        }
        
        if patientTags != nil {
            var arrOfDict = [[String: Any]]()
            for item in patientTags! {
                arrOfDict.append(item.toDict())
            }
            dictionary["patientTags"] = arrOfDict
        }
        
        if leadTags != nil {
            var arrOfDict = [[String: Any]]()
            for item in leadTags! {
                arrOfDict.append(item.toDict())
            }
            dictionary["leadTags"] = arrOfDict
        }
        if triggerData != nil {
            var arrOfDict = [[String: Any]]()
            for item in triggerData! {
                arrOfDict.append(item.toDict())
            }
            dictionary["triggerData"] = arrOfDict
        }
        return dictionary
    }
}

struct MarketingTriggerData : Codable {
    let actionIndex : Int?
    let addNew : Bool?
    let triggerTemplate : Int?
    let triggerType : String?
    let triggerTarget : String?
    let scheduledDateTime : String?
    let triggerFrequency : String?
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
        if scheduledDateTime != nil {
            dictionary["scheduledDateTime"] = scheduledDateTime
        }
        if triggerFrequency != nil {
            dictionary["triggerFrequency"] = triggerFrequency
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
