//
//  StringExtenssion.swift
//  Growth99
//
//  Created by Nitin Auti on 24/08/23.
//

import Foundation

extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }
 }
