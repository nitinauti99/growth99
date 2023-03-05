//
//  LeadHistoryModel.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation

struct LeadHistoryModel: Codable {
    let lastName : String?
    let leadStatus : String?
    let email : String?
    let message : String?
    let leadSource : String?
    let landingPage : String?
    let fullName : String?
    let gender : String?
    let sourceUrl : String?
    let firstName : String?
    let createdAt : String?
    let leadTags : [String]?
    let id : Int?
    let phoneNumber : String?
    let symptoms : String?

    enum CodingKeys: String, CodingKey {

        case lastName = "lastName"
        case leadStatus = "leadStatus"
        case email = "Email"
        case message = "Message"
        case leadSource = "leadSource"
        case landingPage = "landingPage"
        case fullName = "fullName"
        case gender = "Gender"
        case sourceUrl = "sourceUrl"
        case firstName = "firstName"
        case createdAt = "createdAt"
        case leadTags = "leadTags"
        case id = "id"
        case phoneNumber = "Phone Number"
        case symptoms = "Symptoms"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        leadStatus = try values.decodeIfPresent(String.self, forKey: .leadStatus)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        leadSource = try values.decodeIfPresent(String.self, forKey: .leadSource)
        landingPage = try values.decodeIfPresent(String.self, forKey: .landingPage)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        sourceUrl = try values.decodeIfPresent(String.self, forKey: .sourceUrl)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        leadTags = try values.decodeIfPresent([String].self, forKey: .leadTags)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        symptoms = try values.decodeIfPresent(String.self, forKey: .symptoms)
    }

}
