
import UIKit

/// RSSelectionMenuSearchDelegate
open class RSSelectionMenuSearchDelegate: NSObject {
    
    // MARK: - Properties
    public var searchBar: UISearchBar?
    
    /// to execute on search event
    public var didSearch: ((String) -> ())?
    
    // MARK: - Initialize
    init(placeHolder: String, barTintColor: UIColor) {
        super.init()
        searchBar = UISearchBar()
        searchBar?.placeholder = placeHolder
        searchBar?.barTintColor = barTintColor
        searchBar?.sizeToFit()
        searchBar?.delegate = self
        searchBar?.enablesReturnKeyAutomatically = false
    }
    
    /// Search for the text
    func searchForText(text: String?) {
        guard let searchHandler = didSearch else {
            return
        }
        searchHandler(text ?? "")
    }
}

// MARK:- UISearchBarDelegate
extension RSSelectionMenuSearchDelegate : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForText(text: searchText)
    }
}
