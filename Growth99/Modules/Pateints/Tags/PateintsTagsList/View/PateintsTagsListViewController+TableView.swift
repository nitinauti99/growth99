//
//  PateintsTagsListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

extension PateintsTagsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getPateintsTagsFilterData.count ?? 0 == 0 {
                self.pateintsTagsListTableview.setEmptyMessage()
            } else {
                self.pateintsTagsListTableview.restore()
            }
            return viewModel?.getPateintsTagsFilterData.count ?? 0
        } else {
            if viewModel?.getPateintsTagsData.count ?? 0 == 0 {
                self.pateintsTagsListTableview.setEmptyMessage()
            } else {
                self.pateintsTagsListTableview.restore()
            }
            return viewModel?.getPateintsTagsData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.pateintsTagsListTableview.dequeueReusableCell(withIdentifier: "PateintsTagListTableViewCell", for: indexPath) as? PateintsTagListTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        if isSearch {
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "PateintsTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTagsAddViewController") as! PateintsTagsAddViewController
        detailController.pateintsTagScreenName = "Edit Screen"

        if self.isSearch {
            detailController.patientTagId = viewModel?.pateintsTagsFilterListDataAtIndex(index: indexPath.row)?.id ?? 0
        }else{
            detailController.patientTagId = viewModel?.pateintsTagsListDataAtIndex(index: indexPath.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
