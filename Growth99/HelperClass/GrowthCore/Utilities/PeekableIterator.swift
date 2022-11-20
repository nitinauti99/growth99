//
//  PeekableIterator.swift
//  Fargo
//
//  Created by Robin van Dijke on 6/1/16.
//  Copyright © 2016 Apple. All rights reserved.
//

public struct PeekableIterator<Iterator: IteratorProtocol>: IteratorProtocol {
    var iterator: Iterator

    public init(iterator: Iterator) {
        self.iterator = iterator
    }

    public mutating func next() -> Iterator.Element? {
        self.iterator.next()
    }

    public mutating func skipNext() {
        _ = self.iterator.next()
    }

    public func peek() -> Iterator.Element? {
        var iterator = self.iterator

        return iterator.next()
    }
}
