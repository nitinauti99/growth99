//
//  QuestionarieViewController+SearchBar.swift
//  Growth99
//
//  Created by Nitin Auti on 01/03/23.
//

import Foundation
import UIKit

extension QuestionarieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterData(searchText: searchText)
        isSearch = true
        questionarieListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        questionarieListTableView.reloadData()
    }
}
