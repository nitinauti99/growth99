//
//  MassEmailandSMSViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 04/03/23.
//


import Foundation
import UIKit

extension AuditListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getAuditListFilterData.count ?? 0 == 0 {
                self.auditListTableView.setEmptyMessage()
            } else {
                self.auditListTableView.restore()
            }
            return viewModel?.getAuditListFilterData.count ?? 0
        } else {
            if viewModel?.getAuditListData.count ?? 0 == 0 {
                self.auditListTableView.setEmptyMessage()
            } else {
                self.auditListTableView.restore()
            }
            return viewModel?.getAuditListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AuditListTableViewCell", for: indexPath) as? AuditListTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if isSearch {
            cell.configureCell(triggerModuleType: triggerModuleStr, auditFilterList: viewModel?.getAuditListFilterData[indexPath.row], index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(triggerModuleType: triggerModuleStr, auditList:  viewModel?.getAuditListData[indexPath.row], index: indexPath, isSearch: isSearch)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
