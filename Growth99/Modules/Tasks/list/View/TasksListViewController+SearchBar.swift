//
//  TasksListViewController+SearchBar.swift
//  Growth99
//
//  Created by Nitin Auti on 02/03/23.
//

import Foundation
import UIKit

extension TasksListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterData(searchText: searchText)
        isSearch = true
        taskListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        taskListTableView.reloadData()
    }
}
