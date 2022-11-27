
import Foundation

extension NSNumber {

    internal var isBool: Bool { CFBooleanGetTypeID() == CFGetTypeID(self) }

}
