//
//  DispatchSource.swift
//  Dispatch3.0-only
//
//  Created by Robin van Dijke on 9/2/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Dispatch

public extension DispatchSource {
    typealias Add = DispatchSourceUserDataAdd
    typealias Or = DispatchSourceUserDataOr
    typealias MachSend = DispatchSourceMachSend
    typealias MachReceive = DispatchSourceMachReceive
    typealias MemoryPressure = DispatchSourceMemoryPressure
    typealias Process = DispatchSourceProcess
    typealias Read = DispatchSourceRead
    typealias Signal = DispatchSourceSignal
    typealias Timer = DispatchSourceTimer
}
