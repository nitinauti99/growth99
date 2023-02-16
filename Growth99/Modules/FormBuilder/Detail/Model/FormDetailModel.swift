//
//  FormDetailModel.swift
//  Growth99
//
//  Created by Nitin Auti on 15/02/23.
//

import Foundation
struct FormDetailModel: Codable {
    let createdAt : String?
    let updatedAt : String?
    let createdBy : CreatedBy?
    let updatedBy : UpdatedBy?
    let deleted : Bool?
    let tenantId : Int?
    let id : Int?
    let name : String?
    let type : String?
    let answer : String?
    let required : Bool?
    let questionOrder : Int?
    let allowMultipleSelection : Bool?
    let allowLabelsDisplayWithImages : Bool?
    let hidden : Bool?
    let validate : Bool?
    let regex : String?
    let validationMessage : String?
    let showDropDown : Bool?
    let preSelectCheckbox : Bool?
    let description : String?
    let subHeading : String?
    let questionChoices : [String]?
    let questionImages : [String]?
    
}
