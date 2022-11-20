//
//  DispatchIO.swift
//  Dispatch3.0-only
//
//  Created by Robin van Dijke on 9/2/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Dispatch

public extension DispatchIO {

    enum IOError: Error {
        case generic(errorCode: Int32)
    }

    convenience init(test: Bool) {
        self.init(type: .stream, fileDescriptor: 0, queue: .main, cleanupHandler: { _ in })
    }

    convenience init(type: DispatchIO.StreamType, fileDescriptor: FileDescriptor, queue: DispatchQueue = DispatchQueue.main, cleanupHandler: ((Result<Void, IOError>) -> Void)? = nil) {
        let ioPointer = UnsafeMutablePointer<DispatchIO>.allocate(capacity: 1)
        let handler: (Int32) -> Void = { error in
            let io = ioPointer.pointee
            io.close()

            ioPointer.deinitialize(count: 1)
            let result = error == 0 ? Result.success(()) : Result.failure(IOError.generic(errorCode: error))
            cleanupHandler?(result)
        }

        self.init(type: type, fileDescriptor: fileDescriptor, queue: queue, cleanupHandler: handler)

        ioPointer.initialize(to: self)
    }

    /**
     * Defines a (intermittent) read progress
     *
     * The given result contains data which is read or a failure. Done is set to
     * true when all requested data has been read
     */
    typealias ReadProgress = (Result<DispatchData, Error>, done: Bool)

    /**
     * Reads a specific range from the IO instance. Every time a piece of the data is read, the `handler` will
     * be called on the given `handlerQueue`.
     *
     * - parameters:
     *  - range: The range to read
     *  - queue: The queue to call the handler on
     *  - handler: Handler which contains a ReadProgress with read data
     */
    func read(range: Range<Int64>, handlerQueue queue: DispatchQueue, handler: @escaping (ReadProgress) -> Void) {
        self.read(offset: range.lowerBound, length: range.count, queue: queue) { done, data, error in
            let progress: ReadProgress

            if error == 0 {
                assert(data != nil)
                progress = (.success(data!), done: done)
            } else {
                let result: Result<DispatchData, Error> = .failure(IOError.generic(errorCode: error))
                progress = (result, done: done)
            }

            handler(progress)
        }
    }

    /**
     * Defines a (intermittent) write progress
     *
     * The given result contains data how many data is left to write or a failure. Done is set to
     * true when all requested data has been written
     */
    typealias WriteProgress = (Result<Int, Error>, done: Bool)

    /**
     * Writes data to this IO instance. Every time a piece of data is written, the `handler` will be called on
     * the given `handlerQueue`.
     *
     * - parameters:
     *  - data: The data to write
     *  - offset: The offset to start writing from
     *  - handlerQueue: The queue to call the handler on
     *  - handler: The handler to call, contains the remaining data to write
     */
    func write(data: DispatchData, offset: Int64, handlerQueue queue: DispatchQueue, handler: @escaping (WriteProgress) -> Void) {
        self.write(offset: offset, data: data, queue: queue) { done, data, error in
            let progress: WriteProgress

            if error == 0 {
                if done {
                    progress = (.success(0), done: true)
                } else {
                    assert(data != nil)
                    let processed = data!.size
                    progress = (.success(data!.size - processed), done: false)
                }
            } else {
                let result: Result<Int, Error> = .failure(IOError.generic(errorCode: error))
                progress = (result, done: done)
            }

            handler(progress)
        }
    }
}
