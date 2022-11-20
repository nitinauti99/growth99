//
//  AppleCodeValidator.swift
//  FargoCore
//
//  Created by Arun on 12/9/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

public final class AppleCodeValidator {

    private static var lookup: [Character: Int] = [
        "0": 0,
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "9": 8,
        "C": 9,
        "D": 10,
        "F": 11,
        "G": 12,
        "H": 13,
        "J": 14,
        "K": 15,
        "L": 16,
        "M": 17,
        "N": 18,
        "P": 19,
        "Q": 20,
        "R": 21,
        "T": 22,
        "V": 23,
        "W": 24,
        "X": 25,
        "Y": 26
    ]

    /**
     Determines if the specified barcode and type represent an Apple product serial number.
     
     Apple products have serial numbers starting with "S", that
     match the rules described in:
     https://connectme.apple.com/docs/DOC-838931
     */
    public static func isValidAppleSerialNumber(payload: String) -> Bool {
        var payload = payload

        if payload.count == 13,
            let firstCharacter = payload.first,
            firstCharacter == "S" || firstCharacter == "s" {
            payload = payload[1...payload.count - 1]
            return self.isValidAppleSerialNumber(payload: payload)
        }

        let shortLength = payload.count == 11 || payload.count == 12
        let longLength = payload.count == 17 || payload.count == 18

        if shortLength {
            // 2. If the serial number is 11 or 12 characters in length then the following is checked:

            // - It has to be alphanumeric.
            let isAlphanumeric = payload.isAlphanumeric
            // - Characters in position 2, 3, and 4 should be numeric.
            let areChars234Alphanumeric = payload[2...4].isAlphanumeric
            // - Numeric value at position 3 and 4 should lie between 1 and 53.
            var chars34HaveValue1To53 = false
            if payload[3...4].isNumeric,
               let value = Int(payload[3...4]),
               self.isValue(value: value, between: 1, maximum: 53) {
                chars34HaveValue1To53 = true
            }
            
            // - Characters from position 5 to (length of serial number - 3) should not contain
            //   characters 'O', 'o', 'I', 'i'.
            let disallowedCharacterSet = CharacterSet(charactersIn: "OoIi")
            let noDisallowedCharsInChars5ToLenMinus3 = payload[5..<payload.count - 4].rangeOfCharacter(from: disallowedCharacterSet) == .none

            if !isAlphanumeric || !areChars234Alphanumeric || !chars34HaveValue1To53 || !noDisallowedCharsInChars5ToLenMinus3 {
                if payload.count == 12 {
                    // 3. If the serial number is 12 characters in length and fails the validation in
                    //    step 2 above, then:
                    if let firstCharacter = payload.first,
                        firstCharacter == "S" || firstCharacter == "s" {
                        // - If the first character is 'S' or 's', then the remaining 11 character string is
                        //   validated through step 2.
                        payload = payload[1...payload.count - 1]
                        return self.isValidAppleSerialNumber(payload: payload)
                    } else {
                        // Updated Case: Character 3 must be alphanumeric
                        let thirdCharacter = payload[3]
                        let result = isAlphanumeric && ((thirdCharacter >= "A" && thirdCharacter <= "Z") || (thirdCharacter >= "a" && thirdCharacter <= "z"))
                        return result
                    }
                } else {
                    return false
                }
            } else {
                return true
            }
        } else if longLength {
            // 4. If the serial number is 17 or 18 characters in length then Checksum validation is
            //    done.
            return self.checkIfDigitValid(payload: payload)
        } else {
            return false
        }
    }

    /**
     Determines if the specified barcode and type represent an Apple part number.
     
     Apple part numbers must begin with "1P".
     */
    public static func isValidApplePartNumber(payload: String) -> Bool {
        payload.hasPrefix("1P")
    }

    /**
     Determines if the specified barcode and type represent a FGSerialNumber.
     
     If the first character is "S" or "s" then drop it and then checksum is generated to verify.
     */
    public static func isValidFGSerialNumber(payload: String) -> Bool {
        var inputBase27 = payload

        // if first character is 'S' or 's', drop it
        if payload.first == "S" || payload.first == "s" {
            inputBase27 = String(payload.dropFirst())
        }

        if let decimalArray = convertToDecimal(from: inputBase27) {
            return generateChecksum(from: decimalArray)
        } else {
            return false
        }
    }

    /**
     Determines if the specified barcode and type represent a RepairNumber.
     
     The string should start with either "R" or "r" ending by numbers between 0 to 9 with digits length as 8.
     */
    public static func isValidRepairNumber(payload: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "^[Rr][0-9]{8}$") else { return false }

        let range = NSRange(location: 0, length: payload.utf16.count)
        let matchCount = regex.matches(in: payload, options: [], range: range).count

        return matchCount == 1
    }

    /**
     Determines if the specified barcode and type represent a ServicePart.
     
     The payload can be divided into two parts before and after "-".
     First part can have 0-2 letters and 3 digits and second part must contains 4 or 5 digits.
     */
    public static func isValidServicePartBarcode(payload: String) -> Bool {
        payload ~= "[A-Z]{0,2}[0-9]{3}-[0-9]{4,5}"
    }

    /**
     Determines if the specified barcode and type represent a WebOrder.
     
     The payload must start with "W" followed by digits with the length being 9.
     */
    public static func isValidWebOrderBarcode(payload: String) -> Bool {
        payload ~= "[W][0-9]{9}"
    }

    /**
     Determines if the specified barcode and type represent a Repair Barcode.
     
     The payload must start with "R" or "r" followed by digits.
     */
    public static func isValidRepairBarcode(payload: String) -> Bool {
        payload ~= "[Rr][0-9]+"
    }

    /**
     Determines if the specified barcode and type represent a AQC.
     
     The payload's start and end string match OR it starts with "A" followed by characters
     in the range "A" to "Z" and "0" to "9" with the length being 10 .
     */
    public static func isValidAQCBarcode(payload: String) -> Bool {
        let payload = payload.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        return payload ~= "^$|A[A-Z0-9]{10}"
    }

    /**
     Determines if the specified barcode and type represent a DQC.
     
     Payload should start with "D" followed by characters in the range "A" to "Z" and "0" to "9"
     with the length being 8 .
     */
    public static func isValidDQCBarcode(payload: String) -> Bool {
        let payload = payload.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        return payload ~= "D[A-Z0-9]{8}"
    }

    /**
     Determines if the specified barcode and type represent a CTO.
     
     Payload should should  be prefixed with "z" or "1pz" with corresponding length as 4 and 6 respectively.
     Also it should not contain "-" and "/".
     */
    public static func isValidCTOBarcode(payload: String) -> Bool {
        let payload = payload.lowercased()

        guard payload.hasPrefix("z") || payload.hasPrefix("1pz") else { return false }

        if payload.hasPrefix("z") && payload.count < 4 {
            return false
        }

        if payload.hasPrefix("1pz") && payload.count < 6 {
            return false
        }

        if payload.contains("-") || payload.contains("/") {
            return false
        }

        return true
    }

    /**
     Determines if the specified barcode and type represent a IMEI.
     
     Payload should be a numeric with length as 14 or 15.
     */
    public static func isValidIMEIBarcode(payload: String) -> Bool {
        let payload = payload.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        return (payload.count == 14 || payload.count == 15)
    }

    /**
     Determines if the specified barcode and type represent a ReturnReason.
     
     Payload should have a prefix "rr" with the length being 4.
     */
    public static func isValidReturnReasonBarcode(payload: String) -> Bool {
        let payload = payload.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased()

        return payload.hasPrefix("rr") && payload.count == 4
    }

    /**
     Determines if the specified barcode and type represent an IPAddress (IPv4).
     
     Must be presented in Code-128, Code-39, Code-93.
     */
    public static func isValidIPAddress(payload: String) -> Bool {
        guard !payload.hasPrefix("S"), !payload.hasPrefix("1P") else { return false }

        let parts = payload.components(separatedBy: ".")
        let nums = parts.compactMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256 }.count == 4
    }

}

extension AppleCodeValidator {

    private static func isValue(value: Int, between minimum: Int, maximum: Int) -> Bool {
        value >= minimum && value <= maximum
    }

    private static func checkIfDigitValid(payload: String) -> Bool {
        let digits = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"
        let fullRadix = digits.count
        var radix = 10
        var total = 0

        // Loop over characters from right to left with the rightmost character being even
        for index in (0..<payload.count).reversed() {
            let character = payload[index]
            guard digits.contains(character) else { return false }
            guard let characterIndex = digits.indexInt(of: Character(character)) else { return false }
            
            if characterIndex > 9 {
                // Non-numeric digit found, this is a code-34 serial number
                radix = fullRadix
            }

            if index.isMultiple(of: 2) {
                // Even digit, just add value
                total += index
            } else {
                // Odd digit, add 3 times value
                total += 3 * index
            }
        }

        // Verify that total is an even multiple of radix
        return total.isMultiple(of: radix)
    }

    private static func convertToDecimal(from base27: String) -> [Int]? {
        var decimalArray: [Int] = []

        for char in base27 {
            if let decimal = lookup[char] {
                decimalArray.append(decimal)
            } else {
                // invalid base27 character, return nil
                // Log.error("invalid base27 character = \(char), can't convert base27 input to decimal")
                return nil
            }
        }

        return decimalArray
    }

    private static func generateChecksum(from decimalArray: [Int]) -> Bool {
        let allowedMaxDigits = [8, 9, 10, 13, 14]
        guard allowedMaxDigits.contains(decimalArray.count) else { return false }

        let checksumDigit: Int? = decimalArray.last
        var oddDigit = true
        var odds = 0
        var evens = 0

        // From right to left assign each digit to be odd or even, with the rightmost digit being odd.
        for index in (0..<decimalArray.count - 1).reversed() {
            if oddDigit {
                odds += decimalArray[index]
                oddDigit = false
            } else {
                evens += decimalArray[index]
                oddDigit = true
            }
        }

        let result = odds * 3 + evens
        let modulus = result % 27

        if modulus == 0, checksumDigit == 0 {
            return true
        } else if (27 - modulus) == checksumDigit {
            return true
        }

        return false
    }

}
