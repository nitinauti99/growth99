//
//  NibIdentifiable.swift
//  Growth99
//
//  Created by Sravan Goud on 13/02/23.
//

import Foundation
import UIKit

protocol NibIdentifiable: AnyObject {
    static var nib: UINib { get }
}

extension NibIdentifiable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
