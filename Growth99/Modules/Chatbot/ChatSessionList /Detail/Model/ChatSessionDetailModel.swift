//
//  ChatSessionDetailModel.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation

struct ChatSessionDetailModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let message : String?
    let messageBy : String?
    let clientTimestamp : String?
}
