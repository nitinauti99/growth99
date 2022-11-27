
public extension Promise where Wrapped: Possibly {
    /**
     * Completes this promise
     */
    func complete(withValue value: Wrapped.Wrapped) {
        self.future.complete(withValue: value)
    }

    func cancel() {
        self.future.cancel()
    }

}
