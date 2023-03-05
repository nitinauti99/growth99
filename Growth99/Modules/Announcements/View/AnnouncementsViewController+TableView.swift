//
//  AnnouncementsViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import Foundation
import UIKit

extension AnnouncementsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getAnnouncementsFilterData.count ?? 0 == 0 {
                self.announcementsTableView.setEmptyMessage()
            } else {
                self.announcementsTableView.restore()
            }
            return viewModel?.getAnnouncementsFilterData.count ?? 0
        } else {
            if viewModel?.getAnnouncementsData.count ?? 0 == 0 {
                self.announcementsTableView.setEmptyMessage()
            } else {
                self.announcementsTableView.restore()
            }
            return viewModel?.getAnnouncementsData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementsTableViewCell", for: indexPath) as? AnnouncementsTableViewCell else { return UITableViewCell() }
        if isSearch {
            let filteredArray = viewModel?.getAnnouncementsFilterData
            cell.configureCell(announcementsFilterList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
        } else {
            let filteredArray = viewModel?.getAnnouncementsData
            cell.configureCell(announcementsList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
