//
//  DERObject.swift
//  FargoCore
//
//  Created by SopanSharma on 4/9/20.
//

import Foundation

class DERObject {

    /// This property contains the decoded Swift object
    var value: Any?
    /// This property contains the DER encoded object
    var rawValue: Data?
    /// Associated ASN1 tag and class
    var tag: ASN1Tag?
    /// Associated children in case of a constructed type
    var children: [DERObject]?
    /// Associated parent if available
    weak var parent: DERObject?

    func child(at index: Int) -> DERObject? {
        guard let sub = self.children, index >= 0, index < sub.count else { return nil }

        return sub[index]
    }

    func childCount() -> Int {
        self.children?.count ?? 0
    }

    func locateOID(_ oid: OID) -> DERObject? {
        self.locateOID(oid.rawValue)
    }

    func locateOID(_ oid: String) -> DERObject? {
        guard let children = self.children else { return nil }

        for child in children {
            if child.tag?.tagType == .oid {
                if child.value as? String == oid {
                    return child
                }
            } else {
                if let result = child.locateOID(oid) {
                    return result
                }
            }
        }

        return nil
    }

}

extension DERObject {

    subscript(index: TLSCertificateBlockPosition) -> DERObject? {
        guard let children = children, children.indices.contains(index.rawValue) else { return nil }

        return children[index.rawValue]
    }

}
