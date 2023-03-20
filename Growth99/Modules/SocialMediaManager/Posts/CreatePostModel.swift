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
