
import Foundation

public extension Result {

    @discardableResult
    func onSuccess(_ handler: (Success) -> Void) -> Self {
        if case let .success(value) = self {
            handler(value)
        }

        return self
    }

    @discardableResult
    func onFailure(_ handler: (Failure) -> Void) -> Self {
        if case let .failure(error) = self {
            handler(error)
        }

        return self
    }

    /// A Bool value indicating if the `Result` enum is of type `.success`
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    /// A Bool value indicating if the `Result` enum is of type `.failure`
    var isFailure: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }

    /// Represents the `Error` type if the `Result` enum is of type `.failure`
    var error: Failure? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }

    /// Represents the Success value if the `Result` enum is of type `.success`
    var value: Success? {
        switch self {
        case .success(let anySuccessValue):
            return anySuccessValue
        default:
            return nil
        }
    }

}
