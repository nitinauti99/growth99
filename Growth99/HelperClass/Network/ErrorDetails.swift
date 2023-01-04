////
////  ErrorDetails.swift
////  Growth99
////
////  Created by nitin auti on 08/10/22.
////
//
//import Foundation
//struct ErrorDetails: Error, Codable {
//    let status: String?
//    let errorType: String?
//    let errorCode: String?
//    var statusCode: Int?
//    let errorMessage: String?
//    let error: String?
//
//    enum CodingKeys: String, CodingKey {
//        case status
//        case errorType
//        case statusCode
//        case errorMessage
//        case error
//        case errorCode
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        errorType = try values.decodeIfPresent(String.self, forKey: .errorType)
//        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
//        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
//        error = try values.decodeIfPresent(String.self, forKey: .error)
//        errorCode = try values.decodeIfPresent(String.self, forKey: .errorCode)
//    }
//}
