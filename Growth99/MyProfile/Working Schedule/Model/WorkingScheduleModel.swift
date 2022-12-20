//
//  WorkingScheduleModel.swift
//  Growth99
//
//  Created by admin on 12/12/22.
//

import Foundation

struct WorkingScheduleListModel: Codable {
    let id: Int?
    let clinicId: Int?
    let providerId: Int?
    let fromDate: String?
    let toDate: String?
    let scheduleType: String?
    var userScheduleTimings: [WorkingUserScheduleTimings]?
}

struct WorkingUserScheduleTimings: Codable {
    let id: Int?
    let timeFromDate: String?
    let timeToDate: String?
    let days: [String]?
}

struct WorkingDaysModel {
    var title: String
}

struct WorkingParamModel: Codable {
    let userId: Int?
    let clinicId: Int?
    let scheduleType: String?
    let dateFromDate: String?
    let dateToDate: String?
    let dateFrom: String?
    let dateTo: String?
    let providerId: Int?
    let selectedSlots: [SelectedSlots]?
    
    func toDict() -> [String:Any] {
        var dictionary = [String:Any]()
        if userId != nil {
            dictionary["userId"] = userId
        }
        if clinicId != nil {
            dictionary["clinicId"] = clinicId
        }
        if scheduleType != nil {
            dictionary["scheduleType"] = scheduleType
        }
        if dateFromDate != nil {
            dictionary["dateFromDate"] = dateFromDate
        }
        if dateToDate != nil {
            dictionary["dateToDate"] = dateToDate
        }
        if dateFrom != nil {
            dictionary["dateFrom"] = dateFrom
        }
        if dateTo != nil {
            dictionary["dateTo"] = dateTo
        }
        if providerId != nil {
            dictionary["providerId"] = providerId
        }
        if selectedSlots != nil {
            var arrOfDict = [[String: Any]]()
            for item in selectedSlots! {
                arrOfDict.append(item.toDict())
            }
            dictionary["selectedSlots"] = arrOfDict
        }
        return dictionary
    }
    
}

struct SelectedSlots: Codable {
    let timeFromDate: String?
    let timeToDate: String?
    let days: [String]?
    
    func toDict() -> [String: Any] {
        var dictionary = [String:Any]()
        if timeFromDate != nil {
            dictionary["timeFromDate"] = timeFromDate
        }
        if timeToDate != nil {
            dictionary["timeToDate"] = timeToDate
        }
        if days != nil {
            dictionary["days"] = days
        }
        return dictionary
    }
}

