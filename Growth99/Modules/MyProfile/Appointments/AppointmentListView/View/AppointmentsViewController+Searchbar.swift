//
//  AppointmentsViewController+Searchbar.swift
//  Growth99
//
//  Created by Sravan Goud on 30/07/23.
//

import Foundation

extension AppointmentsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getProfileFilterData(searchText: searchText)
        isSearch = true
        appointmentsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        appointmentsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
