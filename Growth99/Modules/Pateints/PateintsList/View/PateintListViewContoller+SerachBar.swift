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
        viewModel?.filterData(searchText: searchText)
        isSearch = true
        pateintListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        pateintListTableView.reloadData()
    }
}

