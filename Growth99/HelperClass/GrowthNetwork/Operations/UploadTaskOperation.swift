
import Foundation

internal class UploadTaskOperation: DataTaskOperation {

    private let data: Data?
    private let url: URL?
    private var observation: NSKeyValueObservation?

    init(_ session: URLSession, _ request: URLRequest, _ completionQueue: DispatchQueue, data: Data?, url: URL?) {
        self.data = data
        self.url = url
        super.init(session, request, completionQueue)
    }

     override func main() {
        guard !self.isCancelled else { return }

        var uploadtask = self.session.uploadTask(withStreamedRequest: self.request)
        if let url = self.url {
            uploadtask = self.session.uploadTask(with: self.request, fromFile: url) { [weak self] data, response, error in
                guard let self = self else { return }

                self.setOperationResponse(with: data, response: response, error: error)
            }
        } else {
            uploadtask = self.session.uploadTask(with: self.request, from: self.data) { [weak self] data, response, error in
                guard let self = self else { return }

                self.setOperationResponse(with: data, response: response, error: error)
            }
        }
        observation = uploadtask.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            guard let self = self else { return }

            self.progressBlock?(uploadtask.progress)
        }

        uploadtask.resume()
        self.delegate?.didStart(operation: self, for: uploadtask)
    }

    private func setOperationResponse(with data: Data?, response: URLResponse?, error: Error?) {
        self.operationResponse = OperationResponse(data: data, response: response, error: error)
        self.isFinished = true
        self.isExecuting = false
        self.observation?.invalidate()
    }

}
