//
//  User.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation
import UIKit

class User {
    private static let firstName = "firstName"
    private static let lastName = "lastName"
    private static let profilePictureUrl = "profilePictureUrl"
    private static let authToken = "authToken"
    private static let primaryMobileNumber = "primaryMobileNumber"
    private static let refreshToken = "refreshToken"
    private static let primaryEmailId = "primaryEmailId"
    private static let isUserLoged = "isUserLoged"
    private static let Xtenantid = "Xtenantid"
    private static let roles = "roles"
    private static let userId = "userId"
    private static let bussinessName = "bussinessName"
    private static let bussinessLogo = "bussinessLogo"

    var authToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.authToken)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.authToken)
        }
    }
    
    var firstName: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.firstName)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.firstName)
        }
    }
    
    var lastName: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.lastName)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.lastName)
        }
    }
    
    var userId: Int? {
         get {
             KeychainWrapper.standard.integer(forKey: User.userId)
         }
         set {
             applyNewValueInKeyChain(value: newValue, key: User.userId)
         }
     }
    
    var roles: String? {
         get {
             KeychainWrapper.standard.string(forKey: User.roles)
         }
         set {
             applyNewValueInKeyChain(value: newValue, key: User.roles)
         }
     }
    
    
    var profilePictureUrl: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.profilePictureUrl)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.profilePictureUrl)
        }
    }
    
    var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: User.refreshToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: User.refreshToken)
        }
    }
    
    var primaryMobileNumber: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.primaryMobileNumber)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.primaryMobileNumber)
        }
    }

    
    var primaryEmailId: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.primaryEmailId)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.primaryEmailId)
        }
    }
   
    var isUserLoged: Bool {
        get {
            UserDefaults.standard.bool(forKey: User.isUserLoged)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: User.isUserLoged)
        }
    }

    var bussinessName: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.bussinessName)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.bussinessName)
        }
    }
    
    var bussinessLogo: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.bussinessLogo)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.bussinessLogo)
        }
    }
    
    var Xtenantid: String? {
        get {
            KeychainWrapper.standard.string(forKey: User.Xtenantid)
        }
        set {
            applyNewValueInKeyChain(value: newValue, key: User.Xtenantid)
        }
    }
    
    func removKeyChainValues() {
        KeychainWrapper.standard.removeObject(forKey: User.authToken)
        KeychainWrapper.standard.removeObject(forKey: User.firstName)
        KeychainWrapper.standard.removeObject(forKey: User.lastName)
        KeychainWrapper.standard.removeObject(forKey: User.profilePictureUrl)
        KeychainWrapper.standard.removeObject(forKey: User.primaryMobileNumber)
        KeychainWrapper.standard.removeObject(forKey: User.refreshToken)
        KeychainWrapper.standard.removeObject(forKey: User.primaryEmailId)
        KeychainWrapper.standard.removeObject(forKey: User.Xtenantid)
        KeychainWrapper.standard.removeObject(forKey: User.userId)
        KeychainWrapper.standard.removeObject(forKey: User.bussinessLogo)
        KeychainWrapper.standard.removeObject(forKey: User.bussinessName)

    }

    private func applyNewValueInKeyChain(value: Any?, key: String) {
        guard let newValue = value else {
            KeychainWrapper.standard.removeObject(forKey: key)
            return
        }
        
        switch newValue {
        case is Int:
            KeychainWrapper.standard.set(newValue as! Int, forKey: key)
        case is String:
            KeychainWrapper.standard.set(newValue as! String, forKey: key)
        default:
            return
        }
    }
}
