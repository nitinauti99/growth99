//
//  LeadTagsListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

extension LeadTagsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getLeadTagsFilterData.count ?? 0
        } else {
            return viewModel?.getLeadTagsData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "LeadTagsListTableViewCell", for: indexPath) as? LeadTagsListTableViewCell else { return UITableViewCell() }

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
        let detailController = UIStoryboard(name: "LeadTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "LeadTagsAddViewController") as! LeadTagsAddViewController
        detailController.leadTagScreenName = "Edit Screen"

        if self.isSearch {
            detailController.leadTagId = viewModel?.leadTagsFilterListDataAtIndex(index: indexPath.row)?.id ?? 0
        }else{
            detailController.leadTagId = viewModel?.leadTagsListDataAtIndex(index: indexPath.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
