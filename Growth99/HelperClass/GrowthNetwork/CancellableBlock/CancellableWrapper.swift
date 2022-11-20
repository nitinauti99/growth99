//
//  CancellableWrapper.swift
//  FargoNetwork
//
//  Created by SopanSharma on 9/19/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

internal class CancellableWrapper: Cancellable {

    var isCancelled = false

    func cancel() {
        self.isCancelled = true
    }
}
