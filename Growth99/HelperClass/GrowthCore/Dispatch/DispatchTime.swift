//
//  DispatchTime.swift
//  Dispatch3.0-only
//
//  Created by Robin van Dijke on 9/2/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Dispatch
import Foundation

public extension DispatchTime {

    /// `Dispatch.Time` timestamp which represents the current time
    static var now: DispatchTime {
        DispatchTime.now()
    }

    /**
     * A `Dispatch.Time` timestamp which represents the current time + the number of nanoseconds
     *
     * - parameter nanoseconds: Nanoseconds from now
     * - returns: DispatchTime instance
     */
    static func nanoseconds(_ nanoseconds: UInt64) -> DispatchTime {
        DispatchTime(uptimeNanoseconds: nanoseconds)
    }

    static var forever: DispatchTime {
        DispatchTime.distantFuture
    }

    /**
     * Initializes a new `Dispatch.Time` instance which lays `seconds` from now
     *
     * - parameter seconds: Number of seconds from the current time
     * - returns: Initialized instance of `Dispatch.Time`
     */
    init(seconds: Foundation.TimeInterval) {
        self = DispatchTime.now() + seconds
    }
}
