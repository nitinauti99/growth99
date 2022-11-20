//
//  Task.swift
//  FargoNetwork
//
//  Created by SopanSharma on 9/26/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

/// - Tag: TaskTag
public enum RequestTask {

    /// A request with no additional data.
    case requestPlain

    /// A requests body set with data.
    case requestData(Data)

    /// A request body set with `Encodable` type
    case requestJSONEncodable(Encodable)

    /// A request body set with `Encodable` type and custom encoder
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)

    /// A file upload task.
    case uploadFile(URL)

    /// A "multipart/form-data" upload task.
    case uploadData(Data)

    /// A file download task with the location for the downloaded file.
    case download(downloadLocationURL: URL)

    /// Multipart upload without parameters
    case multipartUpload([MultipartFormData])

    /// Multipart upload with request parameters
    case multipartCompositeUpload([MultipartFormData], urlParameters: [String: String])

    /// A request body set with encoded parameters.
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)

    /// A request body set with url parameters, will perform urlEncoding.
    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])

    /// A request body set with encoded parameters combined with url parameters.
    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])

}

extension RequestTask: Equatable {

    public static func == (lhs: RequestTask, rhs: RequestTask) -> Bool {
        switch (lhs, rhs) {
        case (let .requestData(lhsData), let .requestData(rhsData)):
            return lhsData == rhsData
        case (let .uploadFile(lhsUrl), let .uploadFile(rhsUrl)):
            return lhsUrl.absoluteString == rhsUrl.absoluteString
        case (let .uploadData(lhsData), let .uploadData(rhsData)):
            return lhsData == rhsData
        case (let .download(downloadLocationURL: lhsDownloadLocationURL), let .download(downloadLocationURL: rhsDownloadLocationURL)):
            return lhsDownloadLocationURL.absoluteString == rhsDownloadLocationURL.absoluteString
        case (let .multipartUpload(lhsMultipartFormData), let .multipartUpload(rhsMultipartFormData)):
            return lhsMultipartFormData == rhsMultipartFormData
        case (let .multipartCompositeUpload(lhsMultipartFormData, lhsParameters), let .multipartCompositeUpload(rhsMultipartFormData, rhsParameters)):
            return lhsMultipartFormData == rhsMultipartFormData && lhsParameters == rhsParameters
        case (let .requestParameters(lhsParameters, lhsEncoding), let .requestParameters(rhsParameters, rhsEncoding)):
            return lhsParameters == rhsParameters && lhsEncoding == rhsEncoding
        case (let .requestCompositeData(lhsBodyData, lhsParameters), let .requestCompositeData(rhsBodyData, rhsParameters)):
            return lhsParameters == rhsParameters && lhsBodyData == rhsBodyData
        case (let .requestCompositeParameters(lhsBodyParameters, lhsEncoding, lhsUrlParameters), let .requestCompositeParameters(rhsBodyParameters, rhsEncoding, rhsUrlParameters)):
            return lhsBodyParameters == rhsBodyParameters && lhsEncoding == rhsEncoding && lhsUrlParameters == rhsUrlParameters
        default:
            return false
        }
    }

}
