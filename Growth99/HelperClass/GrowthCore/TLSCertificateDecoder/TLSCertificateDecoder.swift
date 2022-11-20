//
//  TLSCertificateDecoder.swift
//  FargoCore-iOS
//
//  Created by SopanSharma on 4/7/20.
//
//  Based on https://github.com/filom/ASN1Decoder/
//
//  Copyright © 2017 Filippo Maguolo.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

struct TLSCertificateDecoder {

    func decode(data: Data) throws -> [DERObject] {
        var iterator = data.makeIterator()
        return try self.parse(iterator: &iterator)
    }

    private func parse(iterator: inout Data.Iterator) throws -> [DERObject] {
        var result: [DERObject] = []

        while let nextValue = iterator.next() {
            var derObject = DERObject()
            derObject.tag = ASN1Tag(rawValue: nextValue)

            // If constructed then load the subContent and parse again
            if derObject.tag!.isConstructed {
                let contentData = try self.loadSubContent(iterator: &iterator)

                if contentData.isEmpty {
                    derObject.children = try self.parse(iterator: &iterator)
                } else {
                    var subIterator = contentData.makeIterator()
                    derObject.children = try self.parse(iterator: &subIterator)
                }

                derObject.value = nil
                derObject.rawValue = Data(contentData)

                for item in derObject.children! {
                    item.parent = derObject
                }
            } else {
                if derObject.tag!.typeClass() == .universal {
                    var contentData = try self.loadSubContent(iterator: &iterator)
                    derObject.rawValue = Data(contentData)
                    guard derObject.tag!.tagType != .endOfContent else { return result }

                    self.decodeTagType(derObject: &derObject, contentData: &contentData)
                } else {
                    let contentData = try self.loadSubContent(iterator: &iterator)

                    if let string = String(data: contentData, encoding: .utf8) {
                        derObject.value = string
                    } else {
                        derObject.value = contentData
                    }
                }
            }

            result.append(derObject)
        }

        return result
    }

}

private extension TLSCertificateDecoder {

    func firstBitIsZero(_ value: UInt8) -> Bool {
        value & 0x80 == 0
    }

    func lastSevenBits(_ value: UInt8) -> UInt8 {
        value & 0x7F
    }

    func base128Decode(read bytes: @autoclosure () -> UInt8?) -> Int? {
        var node: Int = 0
        while let byte = bytes() {
            node <<= 7
            node |= Int(byte & 0x7F)
            if byte & 0x80 == 0 {
                return node
            }
        }

        return nil
    }

    //https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-object-identifier?redirectedfrom=MSDN
    func decodeOID(value: Data) -> String {
        var bytes = value
        guard let firstTwoNodes = bytes.popFirst() else { return "" }

        let firstNode = Int(firstTwoNodes / 40)
        let secondNode = Int(firstTwoNodes % 40)
        var nodes: [Int] = [firstNode, secondNode]
        while let node = self.base128Decode(read: bytes.popFirst()) {
            nodes.append(node)
        }

        return nodes.map { String($0) }.joined(separator: ".")
    }

    func length(iterator: inout Data.Iterator) -> UInt64 {
        guard let firstByte = iterator.next() else { return 0 }

        if self.firstBitIsZero(firstByte) {
            return UInt64(firstByte)
        } else {
            let numberOfLengthBytes = UInt64(self.lastSevenBits(firstByte))
            var data = Data()
            for _ in 0..<numberOfLengthBytes {
                if let next = iterator.next() {
                    data.append(next)
                }
            }

            return data.toInt() ?? 0
        }
    }

    func loadSubContent(iterator: inout Data.Iterator) throws -> Data {
        let contentLength = self.length(iterator: &iterator)
        guard contentLength < Int.max else { return Data() }

        var byteArray: [UInt8] = []

        for _ in 0..<Int(contentLength) {
            if let next = iterator.next() {
                byteArray.append(next)
            } else {
                throw DERError.outOfBuffer
            }
        }

        return Data(byteArray)
    }

    func decodeTagType(derObject: inout DERObject, contentData: inout Data) {
        switch derObject.tag!.tagType {

        case .boolean:
            if let value = contentData.first {
                derObject.value = value > 0 ? true : false
            }

        case .integer:
            while contentData.first == 0 {
                contentData.remove(at: 0)
            }

            derObject.value = contentData

        case .null:
            derObject.value = nil

        case .oid:
            derObject.value = decodeOID(value: contentData)

        case .utf8String,
             .printableString,
             .numericString,
             .generalString:

            derObject.value = String(data: contentData, encoding: .utf8)

        case .bmpString:
            derObject.value = String(data: contentData, encoding: .unicode)

        case .visibleString,
             .ia5String:

            derObject.value = String(data: contentData, encoding: .ascii)

        case .utcTime:
            derObject.value = dateFormatter(contentData: &contentData, formats: ["yyMMddHHmmssZ", "yyMMddHHmmZ"])

        case .generalizedTime:
            derObject.value = dateFormatter(contentData: &contentData, formats: ["yyyyMMddHHmmssZ"])

        case .bitString:
            if !contentData.isEmpty { _ = contentData.remove(at: 0) }
            derObject.value = contentData

        case .octet:
            do {
                var subIterator = contentData.makeIterator()
                derObject.children = try self.parse(iterator: &subIterator)
            } catch {
                if let str = String(data: contentData, encoding: .utf8) {
                    derObject.value = str
                } else {
                    derObject.value = contentData
                }
            }

        default:
            derObject.value = contentData
        }
    }

    func dateFormatter(contentData: inout Data, formats: [String]) -> Date? {
        guard let dateString = String(data: contentData, encoding: .utf8) else { return nil }

        for format in formats {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }

        return nil
    }

}
