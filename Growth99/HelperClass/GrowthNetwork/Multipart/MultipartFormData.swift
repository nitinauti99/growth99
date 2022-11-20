//
//  MultipartFormData.swift
//  FargoNetwork
//
//  Created by SopanSharma on 5/15/20.
//

import Foundation

/// Different ways to provide form data
public enum FormDataType {

    /// File url to be uploaded
    case file(URL)
    /// Binary data to be uploaded
    case data(Data)

}

extension FormDataType: Equatable {

    public static func == (lhs: FormDataType, rhs: FormDataType) -> Bool {
        switch (lhs, rhs) {
            case (let .file(lhsURL), let .file(rhsURL)):
                return lhsURL == rhsURL
            case (let .data(lhsData), let .data(rhsData)):
                return lhsData == rhsData
            default:
                return false
        }
    }

}

/// Type representing multipart form data
public struct MultipartFormData {

    /// Represents form data type
    let formDataType: FormDataType

    /// Fieldname associated to the data
    let fieldName: String

    /// File name
    let name: String

    /// Mime type
    let mimeType: String?

    /**
     Initiliazer to create MultipartFormData object with specified properties
     
     - Parameters:
        - formDataType: associated property of formDataType enum
        - fieldName: fieldName
        - name: file name
        - mimeType: mime type
     */
    public init(formDataType: FormDataType,
                fieldName: String,
                name: String,
                mimeType: String? = nil) {
        self.formDataType = formDataType
        self.fieldName = fieldName
        self.name = name
        self.mimeType = mimeType
    }

}
