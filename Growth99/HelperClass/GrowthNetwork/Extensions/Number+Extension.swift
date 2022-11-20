//
//  Number+Extension.swift
//  FargoNetwork
//
//  Created by SopanSharma on 1/8/20.
//

import Foundation

extension NSNumber {

    internal var isBool: Bool { CFBooleanGetTypeID() == CFGetTypeID(self) }

}
