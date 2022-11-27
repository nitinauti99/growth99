public extension Collection where Iterator.Element: Equatable {
    func split(atFirstOccasionOfElement separator: Iterator.Element) -> (SubSequence, SubSequence) {
        let splitted = self.split(separator: separator, maxSplits: 1, omittingEmptySubsequences: false)
        assert(splitted.count == 2)

        return (splitted[0], splitted[1])
    }
}
