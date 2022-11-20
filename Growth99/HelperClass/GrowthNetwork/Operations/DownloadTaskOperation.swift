//
//  DownloadTaskOperation.swift
//  FargoNetwork
//
//  Created by SopanSharma on 10/3/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

class DownloadTaskOperation: DataTaskOperation {

    private let downloadLocationURL: URL
    private var observation: NSKeyValueObservation?

    init(_ session: URLSession, _ request: URLRequest, _ completionQueue: DispatchQueue, downloadLocationURL: URL) {
        self.downloadLocationURL = downloadLocationURL
        super.init(session, request, completionQueue)
    }

     override func main() {
        guard !self.isCancelled else { return }

        let downloadTask = self.session.downloadTask(with: self.request) { [weak self] locationURL, response, error in
            guard let self = self else { return }
            guard let locationURL = locationURL else {
                self.setOperationResponse(response: response, error: error)
                return
            }

            do {
                if FileManager.default.fileExists(atPath: self.downloadLocationURL.path) {
                    try FileManager.default.removeItem(at: self.downloadLocationURL)
                }

                try FileManager.default.moveItem(at: locationURL, to: self.downloadLocationURL)

                self.setOperationResponse(response: response, error: error)
            } catch let error {
                self.setOperationResponse(response: response, error: error)
            }

            self.observation?.invalidate()
        }

        observation = downloadTask.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            guard let self = self else { return }

            self.progressBlock?(downloadTask.progress)
        }
        downloadTask.resume()
        self.delegate?.didStart(operation: self, for: downloadTask)
    }

    private func setOperationResponse(with data: Data = Data(), response: URLResponse?, error: Error?) {
        // In a downloadTask, we receive the location of a temporary file where the data has been stored not the Data.
        self.operationResponse = OperationResponse(data: data, response: response, error: error)
        self.isFinished = true
        self.isExecuting = false
    }

}
