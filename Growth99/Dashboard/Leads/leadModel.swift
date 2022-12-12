//
//  leadModel.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import Foundation

struct leadModel: Codable {
    let lastName: String?
    let leadStatus: String?
    let amount: Int?
    let Email: String?
    let Message: String?
    let leadSource: String?
    let fullName: String?
    let firstName: String?
    let createdAt: String?
    let id: Int?
    let PhoneNumber: String?
    let Symptoms: String?
    let Gender: String?
    let landingPage: String?
    let sourceUrl: String?
    let totalCount: Int?
}

private enum CodingKeys : String, CodingKey {
       case PhoneNumber = "Phone Number"
   }
