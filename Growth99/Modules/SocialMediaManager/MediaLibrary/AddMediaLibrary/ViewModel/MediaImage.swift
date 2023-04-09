//
//  MediaImage.swift
//  Growth99
//
//  Created by Nitin Auti on 25/03/23.
//

import Foundation

enum MediaImage {
    case upload(image: Data, str: [Int])
}

extension MediaImage: Requestable {
    
    var baseURL: String {
        EndPoints.baseURL
    }
    
    var headerFields: [HTTPHeader]? {
        [.custom(key: "x-tenantid", value: UserRepository.shared.Xtenantid ?? String.blank),
             .authorization("Bearer "+(UserRepository.shared.authToken ?? String.blank))]
    }
    
    var requestMode: RequestMode {
        .noAuth
    }
    
    var path: String {
        "/socialMedia/library"
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var task: RequestTask {
        switch self {
        case let .upload(data, str):
            let tagIds = str.map { String($0) }.joined(separator: ",")

            let multipartFormData = [MultipartFormData(formDataType: .data(Data()), fieldName: "tags", name: "\(tagIds)"),
                                    MultipartFormData(formDataType: .data(data), fieldName: "file", name: "filename", mimeType: "image/png")]
            return .multipartUpload(multipartFormData)
        }
    }
}
