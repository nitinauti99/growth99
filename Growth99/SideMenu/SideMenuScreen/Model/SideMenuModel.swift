//
//  SideMenuModel.swift
//  Dentsply Sirona
//
//  Created by sravangoud on 17/08/20.
//  Copyright © 2020 techouts. All rights reserved.
//

import Foundation

struct SideMenuDropdownList {
    var userRole: String?
    var userdesignation: String?
    init(userRole: String, userdesignation: String) {
        self.userRole = userRole
        self.userdesignation = userdesignation
    }
}

struct UserPractices: Codable {
    let ecommerceAccounts: [EcommerceAccounts]?

    enum CodingKeys: String, CodingKey {
        case ecommerceAccounts
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ecommerceAccounts = try values.decodeIfPresent([EcommerceAccounts].self, forKey: .ecommerceAccounts)
    }
}

struct EcommerceAccounts: Codable {
    let uid: String?
    let name: String?
    let active: Bool?
    let selected: Bool?
    let selectable: Bool?
    let administrators: [Administrators]?
    let taxId: String?
    let primaryLicenceNumber: String?
    let accountTypeCode: String?
    let accountStatusCode: String?
    let accountStatusDisplay: String?
    let shippingAddress: ShippingAddress?
    let currentAccount: Bool?
    let currentCustomerRole: CurrentCustomerRole?
    let erpRecords: [ErpRecords]?

    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case active
        case selected
        case selectable
        case administrators
        case taxId
        case primaryLicenceNumber
        case accountTypeCode
        case accountStatusCode
        case accountStatusDisplay
        case shippingAddress
        case currentAccount
        case currentCustomerRole
        case erpRecords
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decodeIfPresent(String.self, forKey: .uid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
        selectable = try values.decodeIfPresent(Bool.self, forKey: .selectable)
        administrators = try values.decodeIfPresent([Administrators].self, forKey: .administrators)
        taxId = try values.decodeIfPresent(String.self, forKey: .taxId)
        primaryLicenceNumber = try values.decodeIfPresent(String.self, forKey: .primaryLicenceNumber)
        accountTypeCode = try values.decodeIfPresent(String.self, forKey: .accountTypeCode)
        accountStatusCode = try values.decodeIfPresent(String.self, forKey: .accountStatusCode)
        accountStatusDisplay = try values.decodeIfPresent(String.self, forKey: .accountStatusDisplay)
        shippingAddress = try values.decodeIfPresent(ShippingAddress.self, forKey: .shippingAddress)
        currentAccount = try values.decodeIfPresent(Bool.self, forKey: .currentAccount)
        currentCustomerRole = try values.decodeIfPresent(CurrentCustomerRole.self, forKey: .currentCustomerRole)
        erpRecords = try values.decodeIfPresent([ErpRecords].self, forKey: .erpRecords)
    }
}

struct Customer: Codable {
    let firstName: String?
    let lastName: String?
    let currency: Currency?
    let language: Language?
    let unit: Unit?
    let email: String?
    let active: Bool?
    let selected: Bool?
    let dentsplyCustomerRole: String?
    let country: Country?
    let profileLanguage: ProfileLanguage?
    let dentsplyCustomerAccountRole: DentsplyCustomerAccountRole?
    let impersonated: Bool?
    let azureId: String?
    let unitsCount: Int?

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case currency
        case language
        case unit
        case email
        case active
        case selected
        case dentsplyCustomerRole
        case country
        case profileLanguage
        case dentsplyCustomerAccountRole
        case impersonated
        case azureId
        case unitsCount
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        currency = try values.decodeIfPresent(Currency.self, forKey: .currency)
        language = try values.decodeIfPresent(Language.self, forKey: .language)
        unit = try values.decodeIfPresent(Unit.self, forKey: .unit)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
        dentsplyCustomerRole = try values.decodeIfPresent(String.self, forKey: .dentsplyCustomerRole)
        country = try values.decodeIfPresent(Country.self, forKey: .country)
        profileLanguage = try values.decodeIfPresent(ProfileLanguage.self, forKey: .profileLanguage)
        dentsplyCustomerAccountRole = try values.decodeIfPresent(DentsplyCustomerAccountRole.self, forKey: .dentsplyCustomerAccountRole)
        impersonated = try values.decodeIfPresent(Bool.self, forKey: .impersonated)
        azureId = try values.decodeIfPresent(String.self, forKey: .azureId)
        unitsCount = try values.decodeIfPresent(Int.self, forKey: .unitsCount)
    }
}

struct Currency: Codable {
    let isocode: String?
    let name: String?
    let active: Bool?
    let symbol: String?

    enum CodingKeys: String, CodingKey {
        case isocode
        case name
        case active
        case symbol
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isocode = try values.decodeIfPresent(String.self, forKey: .isocode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
    }
}

struct Language: Codable {
    let isocode: String?
    let name: String?
    let nativeName: String?
    let active: Bool?
    let required: Bool?

    enum CodingKeys: String, CodingKey {
        case isocode
        case name
        case nativeName
        case active
        case required
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isocode = try values.decodeIfPresent(String.self, forKey: .isocode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nativeName = try values.decodeIfPresent(String.self, forKey: .nativeName)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        required = try values.decodeIfPresent(Bool.self, forKey: .required)
    }
}

struct ProfileLanguage: Codable {
    let isocode: String?
    let name: String?
    let nativeName: String?
    let active: Bool?
    let required: Bool?

    enum CodingKeys: String, CodingKey {
        case isocode
        case name
        case nativeName
        case active
        case required
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isocode = try values.decodeIfPresent(String.self, forKey: .isocode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nativeName = try values.decodeIfPresent(String.self, forKey: .nativeName)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        required = try values.decodeIfPresent(Bool.self, forKey: .required)
    }
}

struct Unit: Codable {
    let uid: String?
    let name: String?
    let active: Bool?
    let selected: Bool?
    let selectable: Bool?
    let administrators: [Administrators]?
    let accountStatusCode: String?
    let accountStatusDisplay: String?
    let currentAccount: Bool?
    let currentCustomerRole: CurrentCustomerRole?
    let erpRecords: [ErpRecords]?

    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case active
        case selected
        case selectable
        case administrators
        case accountStatusCode
        case accountStatusDisplay
        case currentAccount
        case currentCustomerRole
        case erpRecords
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decodeIfPresent(String.self, forKey: .uid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
        selectable = try values.decodeIfPresent(Bool.self, forKey: .selectable)
        administrators = try values.decodeIfPresent([Administrators].self, forKey: .administrators)
        accountStatusCode = try values.decodeIfPresent(String.self, forKey: .accountStatusCode)
        accountStatusDisplay = try values.decodeIfPresent(String.self, forKey: .accountStatusDisplay)
        currentAccount = try values.decodeIfPresent(Bool.self, forKey: .currentAccount)
        currentCustomerRole = try values.decodeIfPresent(CurrentCustomerRole.self, forKey: .currentCustomerRole)
        erpRecords = try values.decodeIfPresent([ErpRecords].self, forKey: .erpRecords)
    }
}

struct DentsplyCustomerAccountRole: Codable {
    let code: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case code
        case name
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct Administrators: Codable {
    let uid: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let currency: Currency?
    let language: Language?
    let displayUid: String?
    let customerId: String?
    let unit: Unit?
    let active: Bool?
    let selected: Bool?
    let roles: [String]?
    let permissionGroups: [String]?
    let approvers: [String]?
    let dentsplyCustomerRole: String?
    let country: Country?
    let dentsplyCustomerAccountRole: DentsplyCustomerAccountRole?
    let impersonated: Bool?

    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case firstName
        case lastName
        case currency
        case language
        case displayUid
        case customerId
        case unit
        case active
        case selected
        case roles
        case permissionGroups
        case approvers
        case dentsplyCustomerRole
        case country
        case dentsplyCustomerAccountRole
        case impersonated
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decodeIfPresent(String.self, forKey: .uid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        currency = try values.decodeIfPresent(Currency.self, forKey: .currency)
        language = try values.decodeIfPresent(Language.self, forKey: .language)
        displayUid = try values.decodeIfPresent(String.self, forKey: .displayUid)
        customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
        unit = try values.decodeIfPresent(Unit.self, forKey: .unit)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
        roles = try values.decodeIfPresent([String].self, forKey: .roles)
        permissionGroups = try values.decodeIfPresent([String].self, forKey: .permissionGroups)
        approvers = try values.decodeIfPresent([String].self, forKey: .approvers)
        dentsplyCustomerRole = try values.decodeIfPresent(String.self, forKey: .dentsplyCustomerRole)
        country = try values.decodeIfPresent(Country.self, forKey: .country)
        dentsplyCustomerAccountRole = try values.decodeIfPresent(DentsplyCustomerAccountRole.self, forKey: .dentsplyCustomerAccountRole)
        impersonated = try values.decodeIfPresent(Bool.self, forKey: .impersonated)
    }
}

struct ErpRecords: Codable {
    let id: String?
    let name: String?
    let erpCode: String?
    let erpRecordStatus: ErpRecordStatus?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case erpCode
        case erpRecordStatus
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        erpCode = try values.decodeIfPresent(String.self, forKey: .erpCode)
        erpRecordStatus = try values.decodeIfPresent(ErpRecordStatus.self, forKey: .erpRecordStatus)
    }
}

struct ErpRecordStatus: Codable {
    let code: String?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case code
        case name
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct Practices: Codable {
    let uid: String?
    let name: String?
    let active: Bool?
    let selected: Bool?
    let selectable: Bool?
    let accountStatusCode: String?
    let accountStatusDisplay: String?
    let shippingAddress: ShippingAddress?
    let currentAccount: Bool?
    let currentCustomerRole: CurrentCustomerRole?
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case active
        case selected
        case selectable
        case accountStatusCode
        case accountStatusDisplay
        case shippingAddress
        case currentAccount
        case currentCustomerRole
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decodeIfPresent(String.self, forKey: .uid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
        selectable = try values.decodeIfPresent(Bool.self, forKey: .selectable)
        accountStatusCode = try values.decodeIfPresent(String.self, forKey: .accountStatusCode)
        accountStatusDisplay = try values.decodeIfPresent(String.self, forKey: .accountStatusDisplay)
        shippingAddress = try values.decodeIfPresent(ShippingAddress.self, forKey: .shippingAddress)
        currentAccount = try values.decodeIfPresent(Bool.self, forKey: .currentAccount)
        currentCustomerRole = try values.decodeIfPresent(CurrentCustomerRole.self, forKey: .currentCustomerRole)
    }
}

struct ShippingAddress: Codable {
    let id: String?
    let line1: String?
    let town: String?
    let region: Region?
    let postalCode: String?
    let phone: String?
    let country: Country?
    let formattedAddress: String?
    let editable: Bool?
    let addressName: String?
    let multilineFormattedAddress: String?
    let oneTime: Bool?
    let cimKey: String?
    enum CodingKeys: String, CodingKey {
        case id
        case line1
        case town
        case region
        case postalCode
        case phone
        case country
        case formattedAddress
        case editable
        case addressName
        case multilineFormattedAddress
        case oneTime
        case cimKey
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        line1 = try values.decodeIfPresent(String.self, forKey: .line1)
        town = try values.decodeIfPresent(String.self, forKey: .town)
        region = try values.decodeIfPresent(Region.self, forKey: .region)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        country = try values.decodeIfPresent(Country.self, forKey: .country)
        formattedAddress = try values.decodeIfPresent(String.self, forKey: .formattedAddress)
        editable = try values.decodeIfPresent(Bool.self, forKey: .editable)
        addressName = try values.decodeIfPresent(String.self, forKey: .addressName)
        multilineFormattedAddress = try values.decodeIfPresent(String.self, forKey: .multilineFormattedAddress)
        oneTime = try values.decodeIfPresent(Bool.self, forKey: .oneTime)
        cimKey = try values.decodeIfPresent(String.self, forKey: .cimKey)
    }
}

struct Region: Codable {
    let isocode: String?
    let isocodeShort: String?
    let countryIso: String?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case isocode
        case isocodeShort
        case countryIso
        case name
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isocode = try values.decodeIfPresent(String.self, forKey: .isocode)
        isocodeShort = try values.decodeIfPresent(String.self, forKey: .isocodeShort)
        countryIso = try values.decodeIfPresent(String.self, forKey: .countryIso)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct Country: Codable {
    let isocode: String?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case isocode
        case name
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isocode = try values.decodeIfPresent(String.self, forKey: .isocode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct CurrentCustomerRole: Codable {
    let code: String?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case code
        case name
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
