//
//  LoginModel.swift
//  Growth99
//
//  Created by nitin auti on 13/10/22.
//

import Foundation

struct LoginModel: Codable {
    let tokenType: String?
    let accessToken: String?
    let refreshToken: String?
    let id: Int?
    let firstName: String?
    let lastName: String?
    let profileImageUrl: String?
    let designation: String?
    let businessId: String?
    let roles: String?
    let permissions: [permissions]
    let logoUrl: String?
    let supportUser: Bool?
    let allowCreateBusiness: Bool?
}

struct permissions: Codable {
    
}
