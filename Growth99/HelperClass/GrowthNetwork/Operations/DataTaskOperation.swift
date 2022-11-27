
import Foundation

internal struct OperationResponse {

    var data: Data?
    var response: URLResponse?
    var error: Error?

}

protocol DataTaskOperationProtocol: AnyObject {
    func didStart(operation: DataTaskOperation, for task: URLSessionTask)
}

 class DataTaskOperation: Operation, Cancellable {

    private let dataTaskLock = ReadersWriterLock(label: "com.apple.ist.remobile.GrowthHTTPNetwork.dataTaskOperation")

    private(set) var request: URLRequest
    let completionQueue: DispatchQueue
    var dataTaskIdentifier: Int?
    var progressBlock: ((Progress) -> Void)?
    var operationResponse: OperationResponse?
    var metrics: Metrics?
    private(set) var session: URLSession
    private var progress = Progress()
    private var observation: NSKeyValueObservation?
    weak var delegate: DataTaskOperationProtocol?

    init(_ session: URLSession, _ request: URLRequest, _ completionQueue: DispatchQueue) {
        self.session = session
        self.request = request
        self.completionQueue = completionQueue
    }

    private var _isFinished: Bool = false
    private var _isExecuting: Bool = false

     override var isAsynchronous: Bool {
        true
    }

     override var isExecuting: Bool {
        get {
            dataTaskLock.read { () -> Bool in
                _isExecuting
            }
        }
        set {
             if _isExecuting != newValue {
                self.willChangeValue(forKey: "isExecuting")
                dataTaskLock.write {
                    self._isExecuting = newValue
                }
                self.didChangeValue(forKey: "isExecuting")
            }
        }
    }

     override var isFinished: Bool {
        get {
            dataTaskLock.read { () -> Bool in
                _isFinished
            }
        }
        set {
            if _isFinished != newValue {
                self.willChangeValue(forKey: "isFinished")
                dataTaskLock.write {
                    self._isFinished = newValue
                }
                self.didChangeValue(forKey: "isFinished")
            }
        }
    }

     override func main() {
        guard !self.isCancelled else { return }
        self.isFinished = false
        self.isExecuting = true
        let dataTask = self.session.dataTask(with: self.request, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            self.operationResponse = OperationResponse(data: data, response: response, error: error)
            self.isExecuting = false
            self.isFinished = true
            self.observation?.invalidate()
        })
        observation = dataTask.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            guard let self = self else { return }

            self.progressBlock?(dataTask.progress)
        }
        dataTask.resume()

        self.delegate?.didStart(operation: self, for: dataTask)
        self.dataTaskIdentifier = dataTask.taskIdentifier
    }

    func updateRequestHeaders(_ httpHeaderFields: [HTTPHeader]) {
        httpHeaderFields.forEach({ request.setValue($0.requestHeaderValue, forHTTPHeaderField: $0.key) })
    }

}
