//
//  LabelsModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//


import Foundation

struct LabelListModel: Codable, Equatable {
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
