//
//  leadListModel.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import Foundation

struct leadListModel : Codable {
      let lastName: String?
      let leadStatus: String?
      let amount: Int?
      let Email: String?
      let Message: String?
      let leadSource: String?
      let leadRead: Bool?
      let fullName: String?
      let firstName: String?
      let createdAt: String?
      let id: Int?
      var PhoneNumber: String?
      let Symptoms: String?
      let Gender: String?
      let landingPage: String?
      let sourceUrl: String?
      let totalCount: Int?
      let totalUnreadLead: Int?
      let questionnaireName: String?

      enum CodingKeys: String, CodingKey {
          case lastName
          case leadStatus
          case amount
          case Email
          case Message
          case leadSource
          case fullName
          case firstName
          case leadRead
          case createdAt
          case id
          case PhoneNumber = "Phone Number"
          case Symptoms
          case Gender
          case landingPage
          case sourceUrl
          case totalCount
          case questionnaireName
          case totalUnreadLead
      }

      init(from decoder: Decoder) throws {
          let values = try decoder.container(keyedBy: CodingKeys.self)
          lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
          leadRead = try values.decodeIfPresent(Bool.self, forKey: .leadRead)
          leadStatus = try values.decodeIfPresent(String.self, forKey: .leadStatus)
          amount = try values.decodeIfPresent(Int.self, forKey: .amount)
          Email = try values.decodeIfPresent(String.self, forKey: .Email)
          Message = try values.decodeIfPresent(String.self, forKey: .Message)
          leadSource = try values.decodeIfPresent(String.self, forKey: .leadSource)
          fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
          firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
          createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
          id = try values.decodeIfPresent(Int.self, forKey: .id)
          PhoneNumber = try values.decodeIfPresent(String.self, forKey: .PhoneNumber)
          Symptoms = try values.decodeIfPresent(String.self, forKey: .Symptoms)
          Gender = try values.decodeIfPresent(String.self, forKey: .Gender)
          landingPage = try values.decodeIfPresent(String.self, forKey: .landingPage)
          sourceUrl = try values.decodeIfPresent(String.self, forKey: .sourceUrl)
          totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
          totalUnreadLead = try values.decodeIfPresent(Int.self, forKey: .totalUnreadLead)
          questionnaireName = try values.decodeIfPresent(String.self, forKey: .questionnaireName)
      }

}
