//
//  ChatSessionListModel.swift
//  Growth99
//
//  Created by Nitin Auti on 10/03/23.
//

import Foundation

struct ChatSessionListModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let firstName : String?
    let lastName : String?
    let email : String?
    let phone : String?
    let clinicIds : String?
}
