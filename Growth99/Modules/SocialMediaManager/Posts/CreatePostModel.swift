//
//  CreatePostModel.swift
//  Growth99
//
//  Created by Nitin Auti on 20/03/23.
//

import Foundation

struct SocialMediaPostLabelsList: Codable, Equatable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let isDefault : Bool?
}

struct SocialProfilesList: Codable, Equatable {
    let id : Int?
    let socialChannel : String?
    let name : String?
}


struct socialMediaPostModel: Codable {
    let socialMediaPostLabel : String?
    let post : String?
    let deleted : Bool?
    let hashtag : String?
    let socialMediaPostImages : [SocialMediaPostImages]?
    let createdAt : String?
    let sent : Bool?
    let isDefault : Bool?
    let name : String?
    let updatedAt : String?
    let socialProfiles : [SocialProfilesList]?
    let createdBy : CreatedBy?
    let tenantId : Int?
    let id : Int?
    let label : String?
    let approvedDate : String?
    let updatedBy : UpdatedBy?
    let postLabels : [PostLabelsEdit]?
    let scheduledDate : String?
    let approved : Bool?
}

struct SocialMediaPostImages : Codable {
    let location : String?
    let fileId : String?
    let deleted : Bool?
    let id : Int?
    let contentType : String?
    let tenantId : Int?
    let updatedBy : UpdatedBy?
    let updatedAt : String?
    let createdAt : String?
    let createdBy : CreatedBy?
    let filename : String?
}

struct PostLabelsEdit : Codable {
    let deleted : Bool?
    let id : Int?
    let socialMediaPostLabel : SocialMediaPostLabelsList?
    let tenantId : Int?
    let updatedBy : UpdatedBy?
    let updatedAt : String?
    let createdAt : String?
    let createdBy : CreatedBy?
}
