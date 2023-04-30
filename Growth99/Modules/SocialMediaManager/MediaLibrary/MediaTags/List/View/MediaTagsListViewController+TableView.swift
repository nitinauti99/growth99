//
//  MediaTagsListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation
import UIKit

extension MediaTagsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getMediaTagsFilterData.count ?? 0
        } else {
            return viewModel?.getMediaTagsData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "MediaTagsListTableViewCell", for: indexPath) as? MediaTagsListTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        if isSearch {
            cell.configureCellWithSearch(questionarieVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "MediaTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "MediaTagsAddViewController") as! MediaTagsAddViewController
        detailController.mediaTagScreenName = "Edit Screen"

        if self.isSearch {
            detailController.mediaTagId = viewModel?.mediaTagsFilterListDataAtIndex(index: indexPath.row)?.id ?? 0
        }else{
            detailController.mediaTagId = viewModel?.mediaTagsListDataAtIndex(index: indexPath.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}
