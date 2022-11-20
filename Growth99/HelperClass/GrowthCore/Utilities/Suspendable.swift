//
//  DispatchObject.swift
//  Fargo
//
//  Created by Robin van Dijke on 4/18/16.
//  Copyright © 2016 Apple. All rights reserved.
//

public protocol Suspendable {
    mutating func resume()
    mutating func suspend() }
