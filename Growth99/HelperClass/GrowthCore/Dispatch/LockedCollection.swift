//
//  LockedCollection.swift
//  Fargo
//
//  Created by Robin van Dijke on 1/10/16.
//  Copyright © 2016 Apple. All rights reserved.
//

public struct LockedCollection<Element>: RangeReplaceableCollection, ExpressibleByArrayLiteral, CustomStringConvertible {
    public typealias Index = Int

    var lock: SynchronousWriteLock = SerialLock(label: "<lockedCollection.lock>")
    var storage: [Element] = []

    public init() { }

    public init(arrayLiteral elements: Element...) {
        // no need to use the lock in the init function
        for element in elements {
            self.storage.append(element)
        }
    }

    public func index(after value: Int) -> Int {
        value + 1
    }

    public mutating func replaceSubrange<C: Collection>(_ subRange: Range<Index>, with newElements: C) where C.Iterator.Element == LockedCollection.Iterator.Element {
        self.lock.write {
            self.storage.replaceSubrange(subRange, with: newElements)
        }
    }

    public var startIndex: Int {
        0
    }

    public var endIndex: Int {
        self.lock.read { self.storage.count }
    }

    public subscript(position: Int) -> Element {
        get {
            self.lock.read { self.storage[position] }
        }

        set {
            self.lock.write {
                self.storage[position] = newValue
            }
        }
    }

    public var description: String {
        self.storage.description
    }
}
