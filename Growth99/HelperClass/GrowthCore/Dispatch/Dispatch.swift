//
//  Dispatch.swift
//  Dispatch3.0-only
//
//  Created by Robin van Dijke on 9/2/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Dispatch

public enum Dispatch {

}

extension DispatchQueue: Suspendable {
    /**
     * Defines the type when creating a new `Queue`
     *
     * - serial: A serial queue which can only execute a single block at a time
     * - concurrent: A concurrent queue which can execute blocks in parallel
     *
     * - seealso: `Dispatch.Queue`
     */
    public enum Kind {
        case serial
        case concurrent
    }

    /**
     * Initializes a new `Queue`
     *
     * - parameters:
     *   - kind: The kind of queue
     *   - qualityOfService: The quality of service
     *   - label: The label of the queue (e.g. com.apple.app.queue)
     */
    public convenience init(kind: Kind, qualityOfService: DispatchQoS = .`default`, label: String, initiallyInactive: Bool = false) {
        let attributes: DispatchQueue.Attributes

        switch kind {
        case .serial:
            if #available(iOS 10, OSX 10.12, *) {
                attributes = initiallyInactive ? .initiallyInactive : []
            } else {
                attributes = []
            }
        case .concurrent:
            if #available(iOS 10, OSX 10.12, *) {
                attributes = initiallyInactive ? [.initiallyInactive, .concurrent] : .concurrent
            } else {
                attributes = .concurrent
            }
        }

        self.init(label: label, qos: qualityOfService, attributes: attributes)
    }
}
