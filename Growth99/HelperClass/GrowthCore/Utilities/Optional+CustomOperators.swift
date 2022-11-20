//
//  Optional+CustomOperators.swift
//  FargoCore-iOS
//
//  Created by Adam Mork on 12/10/19.
//

import Foundation

infix operator ==? : ComparisonPrecedence

/// Returns a Boolean value indicating whether two objects, which may be `nil`, that conform to `Equatable` are equal.
///
/// Equality is defined as `true` if both values are non-nil and equal, or if both are nil.
/// If one is nil and another is not then it evaluates to `false`
///
/// - Parameters:
///   - lhs: An object that may be `nil` to compare.
///   - rhs: Another object that may be `nil` to compare.
public func ==?<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return lhs == rhs
    } else {
        return lhs == nil && rhs == nil
    }
}

infix operator !=? : ComparisonPrecedence

/// Returns a Boolean value indicating whether two objects, which may be `nil`, that conform to `Equatable` are not equal.
///
/// Returns the opposite of ==?
///
/// - Parameters:
///   - lhs: An object that may be `nil` to compare.
///   - rhs: Another object that may be `nil` to compare.
public func !=?<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    !(lhs ==? rhs)
}
