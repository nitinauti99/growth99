//
//  ClassIdentifiable.swift
//  Growth99
//
//  Created by Sravan Goud on 13/02/23.
//

import Foundation
import UIKit

protocol ClassIdentifiable: AnyObject {
    static var reuseId: String { get }
}

extension ClassIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}
