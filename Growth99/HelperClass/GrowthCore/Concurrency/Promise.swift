//
//  Promise.swift
//  Fargo
//
//  Created by Robin van Dijke on 7/5/16.
//  Copyright © 2016 Apple. All rights reserved.
//

/**
 A promise can be used to generate a future which can be completed at a
 later moment.
 */
public final class Promise<Wrapped> {

    /// The underlying future
    public let future: Future<Wrapped>

    /**
     Generates a new empty promise, ready to be completed
     
     - returns: Instance of promise
     */
    public init() {
        self.future = Future<Wrapped>()
    }

    /**
     Resolves this promise with the given value. Note that
     every promise is only allowed to be resolved once.
     
     - parameter value: Value to resolve promise with
     */
    public func resolve(withValue value: Wrapped) {
        self.future.resolve(withValue: value)
    }

    /**
     Resolves this promise with the given future. Once the future
     will be resolved, this promise is resolved as well.
     Note that every promise can only be resolved once. Do not
     call this function together with the resolve(withValue:) function.
     
     - parameter future: Future to resolve this promise with.
     */
    public func resolve(withFuture future: Future<Wrapped>) {
        self.future.resolve(withFuture: future)
    }

}
