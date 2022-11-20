//
//  Transformable.swift
//  Fargo
//
//  Created by Robin van Dijke on 5/13/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

enum TransformError: Error {
    case notTransformable
}

public protocol Transformable {
    func transform<Value>(_ transform: (Self) throws -> Value) rethrows -> Value
    func transform<Value>(_ transform: (Self) throws -> Value?) throws -> Value
}

public extension Transformable {
    func transform<Value>(_ transform: (Self) throws -> Value) rethrows -> Value {
        try transform(self)
    }

    func transform<Value>(_ transform: (Self) throws -> Value?) throws -> Value {
        if let transformed = try transform(self) {
            return transformed
        }

        throw TransformError.notTransformable
    }
}
