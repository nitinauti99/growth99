//
//  VacationModel.swift
//  Growth99
//
//  Created by admin on 26/11/22.
//

import Foundation

struct AddDateModel {
    let dateFromLabelHeight: CGFloat
    let dateFromHeight: CGFloat
    let dateToLabelHeight: CGFloat
    let dateToHeight: CGFloat
}

struct AddTimeModel {
    let timeFromLabelHeight: CGFloat
    let timeFromHeight: CGFloat
    let timeToLabelHeight: CGFloat
    let timeToHeight: CGFloat
}

struct ResponseModel : Codable {
    let message : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}

struct VacationsListModel: Codable {
    let id: Int?
    let clinicId: Int?
    let providerId: Int?
    let fromDate: String?
    let toDate: String?
    let scheduleType: String?
    var userScheduleTimings: [UserScheduleTimings]?
}

struct UserScheduleTimings: Codable {
    let id: Int?
    let timeFromDate: String?
    let timeToDate: String?
    let days: String?
}


struct VacationParamModel: Codable {
    let providerId: Int?
    let clinicId: Int?
    let vacationSchedules: [VacationSchedules]?
    
    func toDict() -> [String:Any] {
        var dictionary = [String:Any]()
        if providerId != nil {
            dictionary["providerId"] = providerId
        }
        if clinicId != nil {
            dictionary["clinicId"] = clinicId
        }
        if vacationSchedules != nil {
            var arrOfDict = [[String: Any]]()
            for item in vacationSchedules! {
                arrOfDict.append(item.toDict())
            }
            dictionary["vacationSchedules"] = arrOfDict
        }
        return dictionary
    }

}

struct VacationSchedules: Codable {
    let startDate: String?
    let endDate: String?
    let time: [Time]?
    
    func toDict() -> [String:Any] {
        var dictionary = [String:Any]()
        if startDate != nil {
            dictionary["startDate"] = startDate
        }
        if endDate != nil {
            dictionary["endDate"] = endDate
        }
        if time != nil {
            var arrOfDict = [[String:Any]]()
            for item in time! {
                arrOfDict.append(item.toDict())
            }
            dictionary["time"] = arrOfDict
        }
        return dictionary
    }
}


struct Time: Codable {
    let startTime: String?
    let endTime: String?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if startTime != nil {
            dictionary["startTime"] = startTime
        }
        if endTime != nil {
            dictionary["endTime"] = endTime
        }
        return dictionary
    }
}
