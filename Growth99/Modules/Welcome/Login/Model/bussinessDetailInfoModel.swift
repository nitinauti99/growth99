//
//  bussinessDetailInfo.swift
//  Growth99
//
//  Created by nitin auti on 17/01/23.
//

import Foundation

struct bussinessDetailInfoModel: Codable {
    let logoUrl: String?
    let name: String?
    let notifyAfterMinute: Int?
    let paymentRefundable: Bool?
    let id: Int?
    let paymentRefundableBeforeHours: Int?
    let subDomainName: String?
    let subDomainWebsiteTemplateId: Int?
    let refundablePaymentPercentage: Int?
    let deleted: Bool?
    let trainingBusiness: Bool?
    let lastNotifyDateTime: String?
    let googleAnalyticsGlobalCodeUrl: String?
    let googleAnalyticsGlobalCode: String?
    let landingPageTrackCode: String?
    let dataStudioCode: String?
    let smsLimit: Int?
    let emailLimit: Int?
    let paidMediaCode: String?
    let syndicationCode: String?
}
