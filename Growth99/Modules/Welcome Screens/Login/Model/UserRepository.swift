//
//  UserRepository.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation
public class UserRepository {
    public static let shared = UserRepository()
    private let user = User()
    private init() {}
    
    public var firstName: String? {
        get {
            user.firstName
        }
        set {
            user.firstName = newValue
        }
    }
    
    public var lastName: String? {
        get {
            user.lastName
        }
        set {
            user.lastName = newValue
        }
    }
    
    public var roles: String? {
        get {
            user.roles
        }
        set {
            user.roles = newValue
        }
    }
    
    public var userId: Int? {
        get {
            user.userId
        }
        set {
            user.userId = newValue
        }
    }
    
    public var profilePictureUrl: String? {
        get {
            user.profilePictureUrl
        }
        set {
            user.profilePictureUrl = newValue
        }
    }
    
    public var authToken: String? {
        get {
            user.authToken
        }
        set {
            user.authToken = newValue
        }
    }

    public var refreshToken: String? {
        get {
            user.refreshToken
        }
        set {
            user.refreshToken = newValue
        }
    }
    
    public var primaryEmailId: String? {
        get {
            user.primaryEmailId
        }
        set {
            user.primaryEmailId = newValue
        }
    }
    
    
     public var primaryMobileNumber: String? {
         get {
             user.primaryMobileNumber
         }
         set {
             user.primaryMobileNumber = newValue
         }
     }
    

    public var isUserLoged: Bool {
        get {
            user.isUserLoged
        }
        set {
            user.isUserLoged = newValue
        }
    }

    public var Xtenantid: String? {
        get {
            user.Xtenantid
        }
        set {
            user.Xtenantid = newValue
        }
    }
    
    public var bussinessName: String? {
        get {
            user.bussinessName
        }
        set {
            user.bussinessName = newValue
        }
    }
    
    public var bussinessLogo: String? {
        get {
            user.bussinessLogo
        }
        set {
            user.bussinessLogo = newValue
        }
    }
    
    public var bussinessId: Int? {
        get {
            user.bussinessId
        }
        set {
            user.bussinessId = newValue
        }
    }
    
    public var subDomainName: String? {
        get {
            user.subDomainName
        }
        set {
            user.subDomainName = newValue
        }
    }
}
