//
//  EndpointsPoints.swift
//  Growth99
//
//  Created by nitin auti on 18/10/22.
//

import Foundation

struct EndPoints {
    static let baseURL = "https://api.growthemr.com/api"
    static let auth = "/auth"
    static let register = "/account/register"
    static let forgotPassword = "/public/users/forgot-password"
    static let VerifyforgotPassword = "/public/users/forgot-password"
    static let userProfile = "/v1/user/"
    static let allClinics = "/v1/clinics/allClinics"
    static let changePassword = "/users/change-password"
    static let serviceCategories = "/v1/clinics/serviceCategories"
    static let service = "/v1/services/serviceCategories"
    static let vacationSendRequest = "/provider/"

}

struct ApiUrl {
    static let auth = EndPoints.baseURL.appending(EndPoints.auth)
    static let register = EndPoints.baseURL.appending(EndPoints.register)
    static let forgotPassword = EndPoints.baseURL.appending(EndPoints.forgotPassword)
    static let VerifyforgotPassword = EndPoints.baseURL.appending(EndPoints.VerifyforgotPassword)
    static let userProfile = EndPoints.baseURL.appending(EndPoints.userProfile)
    static let allClinics = EndPoints.baseURL.appending(EndPoints.allClinics)
    static let changeUserPassword = EndPoints.baseURL.appending(EndPoints.changePassword)
    static let serviceCategories = EndPoints.baseURL.appending(EndPoints.serviceCategories)
    static let service = EndPoints.baseURL.appending(EndPoints.service)
    static let vacationSubmit = EndPoints.baseURL.appending(EndPoints.vacationSendRequest)
}
