//
//  Promise+Possible.swift
//  Fargo
//
//  Created by Robin van Dijke on 5/13/16.
//  Copyright © 2016 Apple. All rights reserved.
//

public extension Promise where Wrapped: Possibly {
    /**
     * Completes this promise
     */
    func complete(withValue value: Wrapped.Wrapped) {
        self.future.complete(withValue: value)
    }

    func cancel() {
        self.future.cancel()
    }

}
