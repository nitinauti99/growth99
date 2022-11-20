//
//  FargoSortDescriptor.swift
//  FargoCore
//
//  Created by Michael Rubin on 2/22/17.
//
//

import Foundation

public struct FargoSortDescriptor<T> {
    let comparator: (T, T) -> ComparisonResult
    let ascending: Bool

    public init(comparator: @escaping (T, T) -> ComparisonResult, ascending: Bool) {
        self.comparator = comparator
        self.ascending = ascending
    }

    public init(_ comparator: @escaping (T, T) -> ComparisonResult, ascending: Bool) {
        self.comparator = comparator
        self.ascending = ascending
    }
}
