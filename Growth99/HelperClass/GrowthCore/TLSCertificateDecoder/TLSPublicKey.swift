//
//  TLSPublicKey.swift
//  FargoCore
//
//  Created by SopanSharma on 4/10/20.
//

import Foundation

public class TLSPublicKey {

    private var keyBlock: DERObject?

    init(pkBlock: DERObject) {
        self.keyBlock = pkBlock
    }

    public var algoOID: String? {
        self.keyBlock?.child(at: 0)?.child(at: 0)?.value as? String
    }

    public var algoName: String? {
        algoIds[algoOID ?? ""]
    }

    var key: Data? {
        guard let algOid = self.algoOID,
            let oid = OID(rawValue: algOid),
            let keyData = self.keyBlock?.child(at: 1)?.value as? Data else { return nil }

        switch oid {
        case .ecPublicKey:
            return keyData

        case .rsaEncryption:
            let decoder = TLSCertificateDecoder()
            guard let publicKeyDERObjects = (try? decoder.decode(data: keyData)) else {
                return nil
            }
            guard let publicKeyModulus = publicKeyDERObjects.first?.child(at: 0)?.value as? Data else {
                return nil
            }
            return publicKeyModulus

        default:
            return nil
        }
    }

}
