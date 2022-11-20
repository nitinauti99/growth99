//
//  OptionalProtocol.swift
//  Fargo
//
//  Created by Robin van Dijke on 7/7/16.
//  Copyright © 2016 Apple. All rights reserved.
//

public protocol OptionalProtocol {
    associatedtype Wrapped

    func analyze(hasValue: (Wrapped) -> Void, hasNone: () -> Void)
}

extension Optional: OptionalProtocol {
    public func analyze(hasValue: (Wrapped) -> Void, hasNone: () -> Void) {
        switch self {
        case .some(let value):
            hasValue(value)
        case .none:
            hasNone()
        }
    }
}
