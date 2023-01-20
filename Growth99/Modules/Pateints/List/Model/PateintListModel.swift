//
//  PateintListModel.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation

struct PateintListModel: Codable {
    let firstName: String?
    let lastName: String?
    let createdAt: String?
    let updatedBy: String?
    let id: Int?
    let createdBy: String?
    let email: String?
    let name: String?
    let patientStatus: String?
    let updatedAt: String?
}

enum PateintStatus: String{
    case NEW = "NEW"
    case EXISTING = "EXISTING"
    
    var leadSatus: String {
        switch self {
        case .NEW:
            return "NEW"
        case .EXISTING:
            return "EXISTING"
        }
    }
}
