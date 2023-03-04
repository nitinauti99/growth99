//
//  leadListViewController+SearchBar.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

extension leadListViewController:  UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.view.ShowSpinner()
            self.currentPage = 0
            self.getleadList()
        }
     }

    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.ShowSpinner()
        self.currentPage = 0
        self.getleadList()
    }
}
