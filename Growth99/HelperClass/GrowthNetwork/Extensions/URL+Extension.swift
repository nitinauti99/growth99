//
//  URL+Extension.swift
//  FargoNetwork
//
//  Created by SopanSharma on 5/15/20.
//

import Foundation
#if os(iOS) || os(watchOS) || os(tvOS)
import MobileCoreServices
#elseif os(macOS)
import CoreServices
#endif

extension URL {

    func mimeType() -> String {
        let pathExtension = self.pathExtension

        if let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
            let mimeType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue() {
            return mimeType as String
        }

        return "application/octet-stream"
    }

}
