//
//  Cancellable.swift
//  FargoNetwork
//
//  Created by SopanSharma on 9/19/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

/// A protocol indicating that an activity or action supports cancellation.
public protocol Cancellable {

    /// A `Bool` value indicating if the activity is cancelled.
    var isCancelled: Bool { get }

    /// Cancel the activity.
    func cancel()
}
