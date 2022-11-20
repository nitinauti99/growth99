//
//  Color+Fargo.swift
//  Fargo
//
//  Created by Robin van Dijke on 9/6/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#if os(iOS)
import UIKit
public typealias Color = UIColor
#else
import Cocoa
public typealias Color = NSColor
#endif

public extension String {
    enum ColorError: Error {
        case invalidHexString(String)
    }

     func parseHexString() throws -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let (first, rest) = self.decompose(), first == "#" else {
            throw ColorError.invalidHexString(self)
        }

        // convert to format rrggbbaa
        var colorString = String(rest)
        switch rest.count {
        case 3:
            // rgb
            colorString += "f"
        case 4:
            // rgba
            // duplicate each element
            colorString = colorString.reduce("") { string, character in
                let characterString = String([character, character])
                return string + characterString
            }
        case 6:
            // rrggbb
            colorString += "ff"
        case 8:
            // rrggbbaa
            break
        default:
            // invalid hex string
            throw ColorError.invalidHexString(self)
        }

        let hexString = "0x" + colorString
        let colorValue: Int64 = hexString.withCString { strtoll($0, nil, 0) }

        let red = CGFloat((colorValue >> 24) & 0xff) / 255.0
        let green = CGFloat((colorValue >> 16) & 0xff) / 255.0
        let blue = CGFloat((colorValue >> 8) & 0xff) / 255.0
        let alpha = CGFloat((colorValue >> 0) & 0xff) / 255.0

        return (red, green, blue, alpha)
    }
}
