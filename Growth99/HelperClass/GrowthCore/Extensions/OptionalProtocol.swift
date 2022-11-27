

public protocol OptionalProtocol {
    associatedtype Wrapped

    func analyze(hasValue: (Wrapped) -> Void, hasNone: () -> Void)
}

extension Optional: OptionalProtocol {
    public func analyze(hasValue: (Wrapped) -> Void, hasNone: () -> Void) {
        switch self {
        case .some(let value):
            hasValue(value)
        case .none:
            hasNone()
        }
    }
}
