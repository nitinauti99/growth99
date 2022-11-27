

public extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        for index in 0 ..< self.count where self[index] == element {
            self.remove(at: index)
            break
        }
    }
}

public extension Array {
    var slice: ArraySlice<Element> {
        ArraySlice(self)
    }

    /// find the first element that satisfies the predicate function and return it without continuing to parse the array.
    // let array = [1, 3, 5, 2, 5, 4]
    // array.find { e in e % 2 == 0 }
    // returns 2 (it won't return all the evens)
    func find(predicate: (Array.Iterator.Element) throws -> Bool) rethrows -> Array.Iterator.Element? {
        for element in self where try predicate(element) {
            return element
        }
        return nil
    }

    /// helper function to return the element along with the index of where it is (index, element)
    func findWithIndex(predicate: (Array.Iterator.Element) throws -> Bool) rethrows -> (Int, Array.Iterator.Element)? {
        for (index, element) in self.enumerated() where try predicate(element) {
            return (index, element)
        }
        return nil
    }

    mutating func sort(by descriptors: [SortDescriptor<Element>]) {
        self.sort(by: { lhs, rhs in
            for descriptor in descriptors {
                switch descriptor.comparator(lhs, rhs) {
                case.orderedAscending:
                    return descriptor.ascending ? true : false
                case.orderedDescending:
                    return descriptor.ascending ? false : true
                case.orderedSame:
                    continue
                }
            }

            return false
        })
    }

    func sorted(by descriptors: [SortDescriptor<Element>]) -> [Element] {
        self.sorted(by: { lhs, rhs in
            for descriptor in descriptors {
                switch descriptor.comparator(lhs, rhs) {
                case.orderedAscending:
                    return descriptor.ascending ? true : false
                case.orderedDescending:
                    return descriptor.ascending ? false : true
                case.orderedSame:
                    continue
                }
            }

            return false
        })
    }
}
