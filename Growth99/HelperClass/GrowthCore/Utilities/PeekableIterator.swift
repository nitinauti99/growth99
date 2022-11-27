
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
