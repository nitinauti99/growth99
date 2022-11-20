//
//  ApproximatelyEquatable.swift
//  FargoCore-iOS
//
//  Created by Adam Mork on 12/10/19.
//

import Foundation

public protocol ApproximatelyEquatable {
    static func approximatelyEqual(lhs: Self, rhs: Self) -> Bool
}

infix operator ~== : ComparisonPrecedence
infix operator ~!= : ComparisonPrecedence

/// Returns a Boolean value indicating whether two objects are "approximately" equal.
/// Object classes need to adopt the `ApproximatelyEquatable` protocol.
/// An object is "approximately" equal to another if their `.approximatelyEqual(_:_)` function evalues to `true`
///
/// Approximate Equality is the inverse of approximate inequality. For any values `a` and `b`,
/// `a ~== b` implies that `a ~!= b` is `false`.
///
/// - Parameters:
///   - lhs: An `Object` to compare.
///   - rhs: Another `Object` to compare.
public func ~==<T: ApproximatelyEquatable>(lhs: T, rhs: T) -> Bool {
    T.approximatelyEqual(lhs: lhs, rhs: rhs)
}

/// Returns a Boolean value indicating whether two objects are not "approximately" equal.
/// Object classes need to adopt the `ApproximatelyEquatable` protocol.
/// An object is "approximately" equal to another if their `.approximatelyEqual(_:_)` function evalues to `false`
///
/// `a ~!= b` implies that `a ~== b` is `true`.
///
/// - Parameters:
///   - lhs: An `Object` to compare.
///   - rhs: Another `Object` to compare.
public func ~!=<T: ApproximatelyEquatable>(lhs: T, rhs: T) -> Bool {
    !T.approximatelyEqual(lhs: lhs, rhs: rhs)
}

infix operator ~==? : ComparisonPrecedence
infix operator ~!=? : ComparisonPrecedence

/// Returns a Boolean value indicating whether two objects, that may be nil, are "approximately" equal.
/// Object classes need to adopt the `ApproximatelyEquatable` protocol.
///
/// Approximate equality is the inverse of approximate inequality. For any values `a` and `b`,
/// `a ~==? b` implies that `a ~!=? b` is `false`.
///
/// - Parameters:
///   - lhs: An `Object` to compare.
///   - rhs: Another `Object` to compare.
public func ~==?<T: ApproximatelyEquatable>(lhs: T?, rhs: T?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return T.approximatelyEqual(lhs: lhs, rhs: rhs)
    } else {
        return lhs == nil && rhs == nil
    }
}

/// Returns a Boolean value indicating whether two objects, that may be nil, are "approximately" equal.
/// Object classes need to adopt the `ApproximatelyEquatable` protocol.
///
/// `a ~!=? b` implies that `a ~==? b` is `true`.
///
/// - Parameters:
///   - lhs: An `Object` to compare.
///   - rhs: Another `Object` to compare.
public func ~!=?<T: ApproximatelyEquatable>(lhs: T?, rhs: T?) -> Bool {
    !(lhs ~==? rhs)
}
