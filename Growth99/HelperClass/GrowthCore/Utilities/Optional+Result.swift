//
//  Optional+ResultType.swift
//  Fargo
//
//  Created by Robin van Dijke on 3/28/16.
//  Copyright © 2016 Apple. All rights reserved.
//

/**
 * Error which is used when converting Optional values to Result
 *
 * - noValue: The Optional is nil when converting to Result
 */
public enum OptionalError: Error {
    case noValue
}

public extension Optional {
    /**
     * Converts the value of this Optional into a Result by applying the
     * given transform function.
     *
     * - parameter transform: Function which transforms Wrapped into a Result<T>
     * - returns: The transformed successful Result or Result.failure with OptionalError.noValue if this == .None
     * - throws: Everything that the transform function throws
     */
    func result<T>(transform: (Wrapped) throws -> Result<T, Error>) rethrows -> Result<T, Error> {
        switch self {
        case .some(let value):
            return try transform(value)
        case .none:
            return .failure(OptionalError.noValue)
        }
    }
}
