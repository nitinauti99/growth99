//
//  CollectionDifference+Additions.swift
//  FargoCore-iOS
//
//  Created by Kushal Jogi on 9/27/21.
//

@available(macOS 10.15, iOS 13, *)
extension CollectionDifference.Change {
    var offset: Int {
        switch self {
        case let .insert(offset, _, _), let .remove(offset, _, _):
            return offset
        }
    }
}
