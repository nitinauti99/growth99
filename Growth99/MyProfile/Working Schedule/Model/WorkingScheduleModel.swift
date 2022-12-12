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
    let userScheduleTimings: [WorkingUserScheduleTimings]?
}

struct WorkingUserScheduleTimings: Codable {
    let id: Int?
    let timeFromDate: String?
    let timeToDate: String?
    let days: [String]?
}
