//
//  UserProfile.swift
//  Growth99
//
//  Created by nitin auti on 10/11/22.
//

import Foundation

struct UserProfile: Codable {
    let isProvider: Bool?
    let lastName: String?
    let clinics: [Clinics]?
    let roles: Roles?
    let services: [Clinics]?
    let firstName: String?
    let phone: String?
    let userServiceCategories: [Clinics]?
    let id: Int?
    let designation: String?
    let profileImageUrl: String?
    let email: String?
    let description: String?
}

struct Clinics: Codable, Equatable {
    let name: String?
    let id: Int?
}

struct Roles: Codable, Equatable {
    let name: String?
    let id: Int?
}

struct Services: Codable, Equatable {
    let name: String?
    let id: Int?
}

struct UserServiceCategories: Codable, Equatable {
    let name: String?
    let id: Int?
}
