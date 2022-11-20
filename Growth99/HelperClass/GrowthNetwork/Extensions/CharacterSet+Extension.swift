//
//  CharacterSet+Extension.swift
//  FargoNetwork
//
//  Created by SopanSharma on 10/18/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

extension CharacterSet {

    static func urlQueryAllowedCharacterSet() -> CharacterSet {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }

}
