//
//  QuestionnaireTemplatesViewController+SearchBar.swift
//  Growth99
//
//  Created by nitin auti on 10/02/23.
//

import Foundation
import UIKit

extension QuestionnaireTemplateListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredTableData = (viewModel?.UserData.filter { $0.firstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
//        isSearch = true
//        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearch = false
//        searchBar.text = ""
//        tableView.reloadData()
    }
}