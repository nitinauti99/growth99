
import Foundation

public protocol ScopedMutex {
    func sync<R>(execute work: () throws -> R) rethrows -> R
    func trySync<R>(execute work: () throws -> R) rethrows -> R?
}

public protocol RawMutex: ScopedMutex {
    associatedtype MutexPrimitive

    /// The raw primitive is exposed as an "unsafe" public property for faster access in some cases
    var unsafeMutex: MutexPrimitive { get set }

    func unbalancedLock()
    func unbalancedTryLock() -> Bool
    func unbalancedUnlock()
}

public extension RawMutex {
    /** RECOMMENDATION: until Swift can inline between modules or at least optimize @noescape closures to the stack, if this file is linked into another compilation unit (i.e. linked as part of the CwlUtils.framework but used from another module) it might be a good idea to copy and paste the relevant `fastsync` implementation code into your file (or module and delete `private` if whole module optimization is enabled) and use it instead, allowing the function to be inlined.
     ~~~
     private extension UnfairLock {
     func fastsync<R>(execute work: @noescape () throws -> R) rethrows -> R {
     os_unfair_lock_lock(&unsafeLock)
     defer { os_unfair_lock_unlock(&unsafeLock) }
     return try work()
     }
     }
     private extension PThreadMutex {
     func fastsync<R>(execute work: @noescape () throws -> R) rethrows -> R {
     pthread_mutex_lock(&unsafeMutex)
     defer { pthread_mutex_unlock(&unsafeMutex) }
     return try work()
     }
     }
     ~~~
     */
    func sync<R>(execute work: () throws -> R) rethrows -> R {
        unbalancedLock()
        defer { unbalancedUnlock() }
        return try work()
    }
    func trySync<R>(execute work: () throws -> R) rethrows -> R? {
        guard unbalancedTryLock() else { return nil }
        defer { unbalancedUnlock() }
        return try work()
    }
}

/// A basic wrapper around the "NORMAL" and "RECURSIVE" `pthread_mutex_t` (a safe, general purpose FIFO mutex). This type is a "class" type to take advantage of the "deinit" method and prevent accidental copying of the `pthread_mutex_t`.
public final class PThreadMutex: RawMutex {
    public typealias MutexPrimitive = pthread_mutex_t

    // Non-recursive "PTHREAD_MUTEX_NORMAL" and recursive "PTHREAD_MUTEX_RECURSIVE" mutex types.
    public enum PThreadMutexType {
        case normal
        case recursive
    }

    public var unsafeMutex = pthread_mutex_t()

    /// Default constructs as ".Normal" or ".Recursive" on request.
    public init(type: PThreadMutexType = .normal) {
        var attr = pthread_mutexattr_t()
        guard pthread_mutexattr_init(&attr) == 0 else {
            preconditionFailure()
        }
        switch type {
        case .normal:
            pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL)
        case .recursive:
            pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        }
        guard pthread_mutex_init(&unsafeMutex, &attr) == 0 else {
            preconditionFailure()
        }
    }

    deinit {
        pthread_mutex_destroy(&unsafeMutex)
    }

    public func unbalancedLock() {
        pthread_mutex_lock(&unsafeMutex)
    }

    public func unbalancedTryLock() -> Bool {
        pthread_mutex_trylock(&unsafeMutex) == 0
    }

    public func unbalancedUnlock() {
        pthread_mutex_unlock(&unsafeMutex)
    }
}

/// A basic wrapper around `os_unfair_lock` (a non-FIFO, high performance lock that offers safety against priority inversion). This type is a "class" type to prevent accidental copying of the `os_unfair_lock`.
/// NOTE: due to the behavior of the lock (non-FIFO) a single thread might drop and reacquire the lock without giving waiting threads a chance to resume (leading to potential starvation of waiters). For this reason, it is only recommended in situations where contention is expected to be rare or the interaction between contenders is otherwise known.
@available(OSX 10.12, iOS 10, *)
public final class UnfairLock: RawMutex {
    public typealias MutexPrimitive = os_unfair_lock

    public init() {
    }

    /// Exposed as an "unsafe" public property so non-scoped patterns can be implemented, if required.
    public var unsafeMutex = os_unfair_lock()

    public func unbalancedLock() {
        os_unfair_lock_lock(&unsafeMutex)
    }

    public func unbalancedTryLock() -> Bool {
        os_unfair_lock_trylock(&unsafeMutex)
    }

    public func unbalancedUnlock() {
        os_unfair_lock_unlock(&unsafeMutex)
    }
}
