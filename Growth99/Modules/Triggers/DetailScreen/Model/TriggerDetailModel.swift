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

struct UserDTOListTrigger : Codable {
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
