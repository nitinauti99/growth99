//
//  ASN1Tag.swift
//  FargoCore-iOS
//
//  Created by SopanSharma on 4/7/20.
//

import Foundation

/// Type containing ASN.1 tag syntax information
// https://ldap.com/ldapv3-wire-protocol-reference-asn1-ber/
struct ASN1Tag {
    //https://en.wikipedia.org/wiki/X.690#BER_encoding
    enum TagClass: UInt8 {
        case universal = 0x00
        case application = 0x40
        case contextSpecific = 0x80
        case `private` = 0xC0
    }
    //https://en.wikipedia.org/wiki/X.690#BER_encoding
    enum TagType: UInt8 {
        case endOfContent = 0x00
        case boolean = 0x01
        case integer = 0x02
        case bitString = 0x03
        case octet = 0x04
        case null = 0x05
        case oid = 0x06
        case utf8String = 0x0C
        case sequence = 0x10
        case set = 0x11
        case numericString = 0x12
        case printableString = 0x13
        case teletaxString = 0x14
        case ia5String = 0x16
        case utcTime = 0x17
        case generalizedTime = 0x18
        case visibleString = 0x1A
        case generalString = 0x1B
        case bmpString = 0x1E
    }

    let rawValue: UInt8

    init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

}

extension ASN1Tag {

    /**
     DER (or rather BER) tag is constructed as follows:
     
     -------------------------------------------------------
     
     Bits              8    7                          6                               5    4    3    2    1
     Purpose      Class        Primitive or Constructed?            Tag Number
     
     -------------------------------------------------------
     
     In order to figure out whether the tag is primitive or constructed we
     would need to validate if the 6th bit is set and we could do that using
     bitwise '&' operator with "0x20" which is nothing but "100000"
     */

    var isPrimitive: Bool {
        (rawValue & 0x20) == 0
    }

    var isConstructed: Bool {
        (rawValue & 0x20) != 0
    }

    // 1F is "11111"
    var tagType: TagType {
        TagType(rawValue: rawValue & 0x1F) ?? .endOfContent
    }

    func typeClass() -> TagClass {
        let tagClasses: [TagClass] = [.application, .contextSpecific, .private]
        let tagClass = tagClasses.filter { (rawValue & $0.rawValue) == $0.rawValue }

        return tagClass.first != nil ? tagClass.first! : TagClass.universal
    }

}
