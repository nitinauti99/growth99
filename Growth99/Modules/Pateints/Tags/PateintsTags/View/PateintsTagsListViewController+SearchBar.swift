//
//  PateintsTagsListViewController+SearchBar.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

extension PateintsTagsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterData(searchText: searchText)
        isSearch = true
        pateintsTagsListTableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        pateintsTagsListTableview.reloadData()
    }
}
