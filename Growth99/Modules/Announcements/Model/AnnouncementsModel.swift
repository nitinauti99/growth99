//
//  AnnouncementsModel.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import Foundation

struct AnnouncementsModel : Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let url : String?
    let description : String?
    let releaseDate : String?
}
