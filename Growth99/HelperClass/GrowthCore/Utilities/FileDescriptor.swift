//
//  FileDescriptor.swift
//  Fargo
//
//  Created by Robin van Dijke on 4/8/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

public typealias FileDescriptor = Int32

public extension FileDescriptor {
    static var stdin: FileDescriptor {
        STDIN_FILENO
    }

    static var stdout: FileDescriptor {
        STDOUT_FILENO
    }

    static var stderr: FileDescriptor {
        STDERR_FILENO
    }
}
