//
//  PateintListViewContoller+SerachBar.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation
import UIKit

extension PateintListViewContoller:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.UserData.filter { $0.firstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        pateintListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        pateintListTableView.reloadData()
    }
}

