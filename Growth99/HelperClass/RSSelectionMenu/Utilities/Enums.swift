
import Foundation
import UIKit

/// SelectionStyle
public enum SelectionStyle {
    case single        // default
    case multiple
}


/// PresentationStyle
public enum PresentationStyle {
    case present       // default
    case push
    case formSheet(size: CGSize?)
    case popover(sourceView: UIView, size: CGSize?, arrowDirection: UIPopoverArrowDirection = .up, hideNavBar: Bool = false)
    case alert(title: String?, action: String?, height: Double?)
    case actionSheet(title: String?, action: String?, height: Double?)
    case bottomSheet(barButton: UIBarButtonItem, height: Double?)
}

/// CellType
public enum CellType {
    case basic          // default
    case rightDetail
    case subTitle
    case customNib(nibName: String, cellIdentifier: String)
    case customClass(type: AnyClass, cellIdentifier: String)
    
    /// Get Value
    func value() -> String {
        switch self {
        case .basic:
            return "basic"
        case .rightDetail:
            return "rightDetail"
        case .subTitle:
            return "subTitle"
        default:
            return "basic"
        }
    }
}


/// Cell Selection Style
public enum CellSelectionStyle {
    case tickmark
    case checkbox
}


/// FirstRowType
public enum FirstRowType {
    
    case empty
    case none
    case all
    case custom(value: String)
    
    // display value
    var value: String {
        switch self {
        case .empty:
            return ""
        case .none:
            return "None"
        case .all:
            return "All"
        case .custom(let value):
            return value
        }
    }
}
