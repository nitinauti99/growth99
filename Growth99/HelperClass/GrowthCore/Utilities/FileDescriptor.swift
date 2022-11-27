
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
