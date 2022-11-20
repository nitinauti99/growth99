//
//  AnyEncodable.swift
//  FargoNetwork
//
//  Created by SopanSharma on 11/4/20.
//

import Foundation

struct AnyEncodable: Encodable {

    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }

}
