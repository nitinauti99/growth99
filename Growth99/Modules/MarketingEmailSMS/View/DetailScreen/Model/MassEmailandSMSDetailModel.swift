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
    let emailTemplateDTOList : [EmailTemplateDTOList]?
    let smsTemplateDTOList : [SmsTemplateDTOList]?
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
    let id : Int?
    let firstName : String?
    let lastName : String?
    let gender : String?
    let profileImageUrl : String?
    let email : String?
    let phone : String?
    let designation : String?
    let description : String?
    let provider : String?
}
