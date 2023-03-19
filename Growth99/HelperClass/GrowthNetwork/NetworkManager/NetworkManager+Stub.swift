

import Foundation

extension NetworkManager {

    @discardableResult
    func stubRequest(stub: Stub,
                     completionQueue: DispatchQueue = DispatchQueue.main,
                     completion: @escaping (Result<GrowthResponse, GrowthNetworkError>) -> Void) -> Cancellable {
        guard self.session != nil else { return CancellableWrapper() }

        let cancellableToken = CancellableWrapper()
        let stubCallback: () -> Void = self.createStubFunction(stubResponse: stub.response, completion: completion)

        switch stub.behavior {
        case .immediate:
            completionQueue.async {
                stubCallback()
            }
        case .delayed(let delay):
            let delayTime = DispatchTime.now() + delay
            completionQueue.asyncAfter(deadline: delayTime) {
                stubCallback()
            }
        case .randomDelay:
            completionQueue.asyncAfter(deadline: DispatchTime.now() + TimeInterval.random(in: 1...5)) {
                stubCallback()
            }
        case .never:
            assertionFailure("Method called to stub request when stubbing is disabled.")
        }

        return cancellableToken
    }

    private func createStubFunction(stubResponse: StubResponse, completion: @escaping (Result<GrowthResponse, GrowthNetworkError>) -> Void) -> (() -> Void) {
        // swiftlint:disable
        return {
            switch stubResponse {
            case .networkResponse(let statusCode, let data):
                let response = GrowthResponse(statusCode: statusCode, data: data)
                completion(.success(response))
            case .networkJSONResponse(let statusCode, let jsonString):
                let data = Data(jsonString.utf8)
                let response = GrowthResponse(statusCode: statusCode, data: data)
                completion(.success(response))
            case .response(let customResponse, let data):
                let response = GrowthResponse(statusCode: customResponse.statusCode, data: data, response: customResponse)
                completion(.success(response))
            case .fileResponse(let statusCode, let url):
                do {
                    let data = try Data(contentsOf: url, options: .mappedIfSafe)
                    let response = GrowthResponse(statusCode: statusCode, data: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(GrowthNetworkError.invalidResponse))
                }
            case .networkError(let error):
                completion(.failure(error))
            case .none:
                // For none, stub will return an empty success response
                let response = GrowthResponse(statusCode: 200, data: Data())
                completion(.success(response))
            }
        }
    }

}
