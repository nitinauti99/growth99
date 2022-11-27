
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

    typealias ReadProgress = (Result<DispatchData, Error>, done: Bool)

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

    typealias WriteProgress = (Result<Int, Error>, done: Bool)

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
