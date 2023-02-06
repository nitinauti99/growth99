//
//  GrowthDateFormats.swift
//  Growth99
//
//  Created by Sravan Goud on 06/02/23.
//

import Foundation

public enum GrowthDateFormats: String {
    case standardDateAndTimeWithT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case standardDateAndTime = "yyyy-MM-dd HH:mm:ss"
    case dateOnly = "dd/MM/yy"
    case standardDate = "dd/MM/yyyy"
    case timeOnly = "h:mm a"
    case dateAndTimeOnly = "dd/MM/yy | h:mm a"
    case isoDateOnly = "yyyy-MM-dd"
    case timeWithMilliseconds = "yyyy-MM-dd HH:mm:ss.SSS"
    case dateAndTimeStandard = "dd/MM/yyyy HH:mm:ss"
    case dateAndTimeStandardFormat = "dd MMM yyyy, hh:mm a"
    case dateAndTimeMinuteSeconds = "dd/MM/yy | hh:mm a"
    case ccDateMonthYear = "dd MMM yyyy"
    case ccMonthDateYear = "MMM dd yyyy"
    case ccDateFullMonthYear = "dd MMMM yyyy"
    case ccFullMonthDateCommaYear = "MMMM dd, yyyy"
    case ccFullMonthDate = "MMMM dd"
    case ccDDMMYYYY = "dd MM yyyy"
    case ccStandardDateFormat = "dd-MM-yyyy"
    case ccddMMMyyyy = "dd-MMM-yyyy"
    case ccdd = "dd"
    case ccMMM = "MMM"
    case ccyyyy = "yyyy"
    case monthYearOnly = "MMM yy"
    case yearMonth = "yyyy-MM"
    case standardDateTAndTime = "yyyy-MM-dd'T'HH:mm:ss"
    case standardDateAndTimeWithMiliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case dateTime = "dd-MM-yyyy HH:mm:ss"
    case ddMMyyyyOnly = "ddMMyyyy"
    case dayWithDateTimeMonthYear = "E, d MMM yyyy, h:mm a"
    case dateTimeDay = "EEE, dd MMM yyyy, hh:mm a"
}
