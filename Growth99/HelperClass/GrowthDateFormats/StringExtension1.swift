//
//  StringExtension1.swift
//  Growth99
//
//  Created by Sravan Goud on 06/02/23.
//

import Foundation
import UIKit

public extension String {
    
    func getStringFormattedDate(inputFormat: String = GrowthDateFormats.standardDateAndTime.rawValue, outputFormat: String = GrowthDateFormats.dateOnly.rawValue) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        guard let date = formatter.date(from: self) else {return ""}
        formatter.dateFormat = outputFormat
        let string = formatter.string(from: date)
        return string
    }
    
    func getFormattedDateWithTimeZone(inputFormat: String = GrowthDateFormats.standardDateAndTime.rawValue, outputFormat: String = GrowthDateFormats.dateOnly.rawValue, _ timeZone: String = "UTC") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone(identifier: timeZone)
        guard let date = formatter.date(from: self) else {return ""}
        formatter.dateFormat = outputFormat
        let string = formatter.string(from: date)
        return string
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        let otherInputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy"
        otherInputFormatter.dateFormat = "yyyy-MM-dd"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        if let date = otherInputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    func getFormattedDate(inputFormat: String = GrowthDateFormats.isoDateOnly.rawValue) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        return formatter.date(from: self)
    }
    
    func getDateFormatString(inputFormat: String, outputFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        guard let date = formatter.date(from: self) else {return ""}
        formatter.dateFormat = outputFormat
        let string = formatter.string(from: date)
        return string
    }
    
    func getFormattedTime(_ inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", _ outputTimeFormat: String = "h:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        guard let date = dateFormatter.date(from: self) else {return ""}
        dateFormatter.dateFormat = outputTimeFormat
        return dateFormatter.string(from: date)
    }
}
