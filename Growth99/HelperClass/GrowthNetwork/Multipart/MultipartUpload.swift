
import Foundation

struct BodyPart {

    let content: Data?
    let mimeType: String?
    let fieldName: String
    let name: String

    init(data: Data?,
         fieldName: String,
         name: String,
         mime: String? = nil) {
        self.content = data
        self.fieldName = fieldName
        self.name = name
        self.mimeType = mime
    }

}

final class MultipartUpload {

    private struct Constants {
        static let crlfCharacters = "\r\n"
    }

    var body: Data {
        var bodyData = Data()
        // Step 1
        let bodyParts = self.bodyParts(for: self.multipartFormDataList)
        // Step 2
        let failedFiles = self.add(bodyParts: bodyParts, toBody: &bodyData, withBoundary: self.boundary)
        if !failedFiles.isEmpty {
            Log.error("MultipartUpload: Error while parsing files \(failedFiles)", logger: OSLogger.shared, shouldLog: true)
        }
        // Step 3
        self.close(body: &bodyData, usingBoundary: self.boundary)

        return bodyData
    }

    let multipartFormDataList: [MultipartFormData]
    let boundary: String

    lazy var multipartFormHeader = HTTPHeader.custom(key: "Content-Type", value: "multipart/form-data; boundary=\(self.boundary)")

    init(multipartFormDataList: [MultipartFormData]) {
        self.multipartFormDataList = multipartFormDataList
        self.boundary = BoundaryGenerator.createBoundary()
    }

    /**
     Create body data based on below encoding:
     
     - `Content-Disposition: form-data; name=#{name}; filename=#{filename}` (HTTP Header)
     - `Content-Type: #{mimeType}` (HTTP Header)
     
     - Parameters:
        - files: datastructure to denote parts of data to be uploaded
        - body: bodyData which is to be constructed
        - boundary: boundary string to be used for encoding
     
     - Returns:
        Files which failed to encode
     */
    @discardableResult
    func add(bodyParts: [BodyPart], toBody body: inout Data, withBoundary boundary: String) -> [String] {
        var status = true
        var failedFilenames = [String]()

        for bodyPart in bodyParts {
            guard let content = bodyPart.content else {
                Log.debug("MultipartUpload: File content is nil, continue with other files", logger: OSLogger.shared, shouldLog: true)
                continue
            }

            status = false
            var data = Data()
            var formattedBody = [String]()

            if let mimeType = bodyPart.mimeType {
                formattedBody = ["--\(boundary)\(Constants.crlfCharacters)",
                                 "Content-Disposition: form-data; name=\"\(bodyPart.fieldName)\"; filename=\"\(bodyPart.name)\"\r\n",
                                 "Content-Type: \(mimeType)\r\n\(Constants.crlfCharacters)"]
            } else {
                formattedBody = ["--\(boundary)\(Constants.crlfCharacters)",
                                 "Content-Disposition: form-data; name=\"\(bodyPart.fieldName)\"; filename=\"\(bodyPart.name)\"\r\n\(Constants.crlfCharacters)"]
            }

            // Append headers
            if data.append(values: formattedBody) {
                // Append data
                if data.append(values: [content]) {
                    // Append closing crlf encoding characters
                    if data.append(values: [Constants.crlfCharacters]) {
                        status = true
                    }
                }
            }

            if status {
                body.append(data)
            } else {
                failedFilenames.append(bodyPart.fieldName)
            }
        }

        return failedFilenames
    }

    func close(body: inout Data, usingBoundary boundary: String) {
        body.append(values: ["\(Constants.crlfCharacters)--\(boundary)--\(Constants.crlfCharacters)"])
    }

    // MARK: Private Helpers

    private func bodyParts(for multiparts: [MultipartFormData]) -> [BodyPart] {
        var files = [BodyPart]()

        for multipart in multiparts {
            switch multipart.formDataType {
            case .data(let data):
                let file = BodyPart(data: data, fieldName: multipart.fieldName, name: multipart.name)
                files.append(file)
            case .file(let fileUrl):
                let data = try? Data(contentsOf: fileUrl)
                let file = BodyPart(data: data, fieldName: multipart.fieldName, name: multipart.name, mime: multipart.mimeType ?? fileUrl.mimeType())
                files.append(file)
            }
        }

        return files
    }

}

struct BoundaryGenerator {

    static func createBoundary() -> String {
        var uuid = UUID().uuidString
        uuid = uuid.replacingOccurrences(of: "-", with: "")
        uuid = uuid.map { $0.lowercased() }.joined()

        let boundary = String(repeating: "-", count: 20) + uuid + "\(Int(Date.timeIntervalSinceReferenceDate))"

        return boundary
    }

}
