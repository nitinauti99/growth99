//
//  LabelsViewController+SearchBar.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/23.
//

import Foundation
import UIKit

extension LabelListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterData(searchText: searchText)
        isSearch = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
