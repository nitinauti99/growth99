////
////  ErrorResponse.swift
////  Growth99
////
////  Created by nitin auti on 08/10/22.
////
//
//import Foundation
//
//struct ErrorResponse: Codable {
//    let status, message, errorCode, errorMessage, errorReason, error: String?
//    let code: ResponseErrorCode?
//}
//
//public enum ResponseErrorCode: String, Codable {
//    case previousPassword = "SSO-1008"
//    case incorrectOldPassword = "SSO-1011"
//    case blacklistedPassword = "SSO-1005"
//    case existingEmail = "GR-UP-EMAIL-EXISTS-400"
//    case incorrectInput = "No value present"
//    case incorrectPasswordInput = "BAD_REQUEST"
//    case invalidPhoneNumber = "SSO-1026"
//    case inValidPassword = "SSO-1058"
//    case invalidEmailRefId = "SSO-1052"
//    case invalidOTP = "SSO-1051"
//    case usedOtp = "SSO-1050"
//    case otpExpired = "SSO-1049"
//    case emailExistAlready = "SSO-1037"
//    case emptyOtp = "SSO-1048"
//    case refIdEmpty = "SSO-1047"
//    case otpNotVerfied = "SSO-1046"
//    case verifCodeExp = "SSO-1043"
//    case invalidVerfCode = "SSO-1042"
//    case enterEmail = "SSO-1059"
//    case invalidFirstName = "SSO-1018"
//    case invalidLastName = "SSO-1019"
//    case invalidCredentials = "400"
//    case exhausteAllLoginAttempt = "SSO-1038"
//    case unregisteredEmail = "SSO-1057"
//    case expiredPasswordToken = "SSO-1010"
//    case passwordMismatch = "SSO-1009"
//    case invalidCountryCode = "SSO-1027"
//}
