//
//  Registration.swift
//  Growth99
//
//  Created by nitin auti on 03/11/22.
//

import Foundation
import Alamofire

struct RegistrationModel: Codable, EmptyResponse {
    static func emptyValue() -> RegistrationModel {
        return RegistrationModel.init()
    }
}
