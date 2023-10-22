//
//  SocialProfilesModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

struct SocialProfilesListModel: Codable, Equatable {
    let name: String?
    let socialChannel: String?
    let id: Int?
}

struct SocialProfilesListRemove: Codable {
    let success: String?
}

struct SocialProfileLinkModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : SocialCreatedBy?
    let updatedBy : SocialUpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let socialChannel : String?
    let name : String?
    let socialIdentity : String?
    let socialPagesId : SocialPagesId?
}

struct SocialPagesId: Codable {
      let pageId : String?
      let deleted : Bool?
      let id : Int
}

struct SocialUpdatedBy: Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}

struct SocialCreatedBy: Codable {
    let firstName : String?
    let lastName : String?
    let email : String?
    let username : String?
}
