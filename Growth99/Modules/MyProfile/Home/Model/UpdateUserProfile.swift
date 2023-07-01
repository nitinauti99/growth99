//
//  UpdateUserProfile.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation

struct UpdateUserProfile: Codable {
    let createdBy: CreatedBy?
    let updatedBy: UpdatedBy?
    let email: String?
    let username: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    let isProvider: Bool?
    let tenantId: Int?
    let profileImageUrl: String?
    let designation: String?
    let description: String?
    let id: Int?
    let status: Int?
}

struct CreatedBy: Codable, Equatable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let username: String?
    
    func toDict() -> [String:Any] {
        var dictionary = [String:Any]()
        if firstName != nil {
            dictionary["firstName"] = firstName
        }
        if lastName != nil {
            dictionary["lastName"] = lastName
        }
        if email != nil {
            dictionary["email"] = email
        }
        if username != nil {
            dictionary["username"] = username
        }
        return dictionary
    }
}

struct UpdatedBy: Codable, Equatable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let username: String?
    
    func toDict() -> [String:Any] {
        var dictionary = [String:Any]()
        if firstName != nil {
            dictionary["firstName"] = firstName
        }
        if lastName != nil {
            dictionary["lastName"] = lastName
        }
        if email != nil {
            dictionary["email"] = email
        }
        if username != nil {
            dictionary["username"] = username
        }
        return dictionary
    }
}
