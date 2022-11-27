
public extension Collection {

    func decompose() -> (Iterator.Element, SubSequence)? {
        var generator = self.makeIterator()

        guard let first = generator.next() else {
            return nil
        }

        return (first, self.dropFirst())
    }

    /// Group elements of a Sequence using the specificed key in the closure
    ///
    /// - Parameter groupClosure: grouping closure
    /// - Returns: Grouped Sequence with keys as the group key, values as [Iterator.Element]
    func grouped<U: Hashable>(by groupClosure: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var groups: [U: [Iterator.Element]] = [:]

        for element in self {
            let key = groupClosure(element)

            // append to an existing one or create a new group if there is none
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
            }
        }

        return groups
    }

    /// Group elements of a Sequence using the specificed key in the closure, taking an optional attribute key with a provided empty key
    ///
    /// - Parameters:
    ///   - groupClosure: grouping closure
    ///   - emptyKey: key to use for group name when the groupby attribute value is nil
    /// - Returns: Grouped Sequence with keys as the group key, values as [Iterator.Element]
    func grouped<U: Hashable>(by groupClosure: (Iterator.Element) -> U?, withEmptyKey emptyKey: U) -> [U: [Iterator.Element]] {
        var groups: [U: [Iterator.Element]] = [:]

        for element in self {
            let key = groupClosure(element) ?? emptyKey

            // append to an existing one or create a new group if there is none
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
            }
        }

        return groups
    }
}
