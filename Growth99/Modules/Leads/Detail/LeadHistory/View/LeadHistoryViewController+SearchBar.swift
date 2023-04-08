//
//  LeadHistoryViewController+SearchBar.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

extension LeadHistoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterData(searchText: searchText)
        isSearch = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
