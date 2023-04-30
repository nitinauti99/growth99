//
//  MediaLibraryListViewController+SearchBar.swift
//  Growth99
//
//  Created by Nitin Auti on 29/04/23.
//

import Foundation
import UIKit

extension MediaLibraryListViewController:  UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.view.ShowSpinner()
            self.page = 0
            self.viewModel?.getSocialMediaLibrariesList(page: page ?? 0, size: size ?? 10, search: searchBar.text ?? "", tags: 0)
        }
     }

    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.ShowSpinner()
        self.page = 0
        self.viewModel?.getSocialMediaLibrariesList(page: page ?? 0, size: size ?? 10, search: searchBar.text  ?? "", tags: 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
