//
//  Keychain.swift
//  FargoCore
//
//  Created by Vashishtha Jogi on 7/25/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//  Contributions by Sopan Sharma

import Foundation
import Security

public enum FargoKeychainAccessOptions {

    /**

      The data in the keychain item can be accessed only while the device is unlocked by the user.

      This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.

      This is the default value for keychain items added without explicitly setting an accessibility constant.

      */
    case accessibleWhenUnlocked

    /**

      The data in the keychain item can be accessed only while the device is unlocked by the user.

      This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.

      */
    case accessibleWhenUnlockedThisDeviceOnly

    /**

      The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.

      After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.

      */
    case accessibleAfterFirstUnlock

    /**

      The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.

      After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.

      */
    case accessibleAfterFirstUnlockThisDeviceOnly

    /**

      The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.

      This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.

      */
    case accessibleWhenPasscodeSetThisDeviceOnly

    static var defaultOption: FargoKeychainAccessOptions {
        .accessibleWhenUnlocked
    }

    var value: String {
        switch self {
        case .accessibleWhenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)

        case .accessibleWhenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)

        case .accessibleAfterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)

        case .accessibleAfterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)

        case .accessibleWhenPasscodeSetThisDeviceOnly:
            return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        }
    }

}

/// Errors encountered when during read/write of keychain items
///
/// - noPassword: No password found in the Keychain.
/// - unexpectedPasswordData: Unable to parse password data from the Keychain. Expected String but was something else.
/// - invalidPassword: Invalid password. Expecting a valid UTF-8 String.
/// - genericError: For a generic OSStatus which is not any of above 3 errors.
public enum KeychainError: LocalizedError {

    case noPassword
    case unexpectedPasswordData
    case invalidPassword
    case genericError(message: String)

    public var errorDescription: String? {
        switch self {
        case.noPassword:
            return "No password found in the Keychain."
        case.unexpectedPasswordData:
            return "Unable to parse password data from the Keychain. Expected String but was something else."
        case.invalidPassword:
            return "Invalid password. Expecting a valid UTF-8 String."
        case.genericError(let message):
            return message
        }
    }

}

/// Swift wrapper over Keychain read/write methods from `Security.framework`
public class Keychain {

    internal var service: String = ""
    internal var accessGroup: String?

    public init(service: String = Bundle.main.bundleIdentifier!, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }

    /// Read saved value for a specified key
    ///
    /// - Parameters:
    ///   - key: key with which the value is attached to
    /// - Returns: string for the specified key
    /// - Throws: `KeychainError` if it encounters any error
    public func readValue(forKey key: String) throws -> String {
        var readQuery = self.buildQuery(service: self.service, account: key, group: self.accessGroup)

        readQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        readQuery[String(kSecReturnAttributes)] = kCFBooleanTrue
        readQuery[String(kSecReturnData)] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(readQuery as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data,
                let password = String(data: passwordData, encoding: .utf8) else {
                    throw KeychainError.unexpectedPasswordData
            }
            return password
        case errSecItemNotFound:
            throw self.error(from: status)
        default:
            throw self.error(from: status)
        }
    }

    /// Save a string value for a specified key
    ///
    /// - Parameters:
    ///   - value: string to be saved
    ///   - key: the key with which the value is associated
    ///   - option: access option to decide when can the value be accessed
    /// - Throws: `KeychainError` if it encounters any error
    public func save(value: String,
                     forKey key: String,
                     option access: FargoKeychainAccessOptions? = nil) throws {
        // Encode the password into an Data object.
        guard let encodedPassword = value.data(using: .utf8) else {
            throw KeychainError.invalidPassword
        }

        var saveQuery = self.buildQuery(service: self.service, account: key, group: self.accessGroup, option: access)
        var status = SecItemCopyMatching(saveQuery as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword
            status = SecItemUpdate(saveQuery as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw self.error(from: status)
            }
        case errSecItemNotFound:
            saveQuery[String(kSecValueData)] = encodedPassword
            status = SecItemAdd(saveQuery as CFDictionary, nil)
            if status != errSecSuccess {
                throw self.error(from: status)
            }
        default:
            throw self.error(from: status)
        }
    }

    /// Remove specific value associated to a key
    ///
    /// - Throws: `KeychainError` if it encounters any error
    public func deleteValue(forkey key: String) throws {
        let query = self.buildQuery(service: self.service, account: key, group: self.accessGroup)

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw self.error(from: status)
        }
    }

    /// Remove all saved data for the specified service and accessGroup
    ///
    /// - Throws: `KeychainError` if it encounters any error
    public func removeAllValues() throws {
        let query = self.buildQuery(service: self.service, group: self.accessGroup)

        let status = SecItemDelete(query as CFDictionary)
        // Throw an error if an unexpected status was returned.
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw self.error(from: status)
        }
    }

    private func error(from status: OSStatus) -> KeychainError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return KeychainError.genericError(message: message + " Error code: \(status)")
    }

}

extension Keychain {

    private func buildQuery(service: String,
                            account: String? = nil,
                            group: String? = nil,
                            option access: FargoKeychainAccessOptions? = nil) -> [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service

        let accessOption = access?.value ?? FargoKeychainAccessOptions.defaultOption.value
        query[String(kSecAttrAccessible)] = accessOption

        if let account = account {
            query[String(kSecAttrAccount)] = account
        }
        // Access group if target environment is not simulator
        #if !targetEnvironment(simulator)
        if let accessGroup = self.accessGroup { query[String(kSecAttrAccessGroup)] = accessGroup
        }
        #endif

        return query
    }

}
