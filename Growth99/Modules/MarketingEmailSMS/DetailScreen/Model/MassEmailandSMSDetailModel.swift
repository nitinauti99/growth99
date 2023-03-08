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

struct EmailTemplateDTOList : Codable {
    let id : Int?
    let name : String?
    let emailTarget : String?
    let templateFor : String?
}

struct SmsTemplateDTOList : Codable {
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
}

struct MassEmailSMSCountModel : Codable {
    let smsCount : Int?
    let emailCount : Int?
}
