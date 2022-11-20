//
//  NSOperationQueue+Context.swift
//  Fargo
//
//  Created by Robin van Dijke on 4/20/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

public extension OperationQueue {
    /// Retrieves a context which can be used to schedule work on
    var context: DispatchQueue.Context {
        self.addOperation(_:)
    }
}
