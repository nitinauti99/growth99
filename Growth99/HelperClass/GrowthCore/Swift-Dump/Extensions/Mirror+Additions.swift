//
//  Mirror+Additions.swift
//  FargoCore-iOS
//
//  Created by Kushal Jogi on 9/27/21.
//

/// Mirrors the FargoDumprepresentable components

extension Mirror {
    var isSingleValueContainer: Bool {
        switch self.displayStyle {
        case .collection?, .dictionary?, .set?:
            return false
        default:
            guard self.children.count == 1, let child = self.children.first else {
                return false
            }
            var value = child.value
            while let representable = value as? FargoDumpRepresentable {
                value = representable.fargoDumpValue
            }
            if let convertible = child.value as? FargoDumpStringConvertible {
                return !convertible.fargoDumpDescription.contains("\n")
            }
            return Mirror(fargoDumpReflecting: value).children.isEmpty
        }
  }
}
