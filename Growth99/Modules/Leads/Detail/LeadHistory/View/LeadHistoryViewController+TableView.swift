//
//  LeadHistoryViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

extension LeadHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getLeadHistroyFilterData.count ?? 0
        } else {
            return viewModel?.getLeadHistroyData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadHistoryListTableViewCell", for: indexPath) as? LeadHistoryListTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        if isSearch {
            cell.configureCellWithSearch(userVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = [ "selectedIndex" : 0 ]
        let detailController = UIStoryboard(name: "LeadDetailContainerView", bundle: nil).instantiateViewController(withIdentifier: "LeadDetailContainerView") as! LeadDetailContainerView
        
        if isSearch{
            detailController.workflowLeadId = viewModel?.leadHistoryFilterDataAtIndex(index: indexPath.row)?.id ?? 0
            let user = UserRepository.shared
            user.leadId = viewModel?.leadHistoryFilterDataAtIndex(index: indexPath.row)?.id ?? 0
            user.leadFullName = (viewModel?.leadHistoryFilterDataAtIndex(index: indexPath.row)?.firstName ?? "") + " " + (viewModel?.leadHistoryFilterDataAtIndex(index: indexPath.row)?.lastName ?? "")

            detailController.leadData = viewModel?.leadHistoryFilterDataAtIndex(index: indexPath.row)
        }else{
            detailController.workflowLeadId = viewModel?.leadHistoryDataAtIndex(index: indexPath.row)?.id ?? 0
            let user = UserRepository.shared
            user.leadId = viewModel?.leadHistoryDataAtIndex(index: indexPath.row)?.id ?? 0
            user.leadFullName = (viewModel?.leadHistoryDataAtIndex(index: indexPath.row)?.firstName ?? "") + " " + (viewModel?.leadHistoryDataAtIndex(index: indexPath.row)?.lastName ?? "")

            detailController.leadData = viewModel?.leadHistoryDataAtIndex(index: indexPath.row)
        }
        NotificationCenter.default.post(name: Notification.Name("changeLeadSegment"), object: nil,userInfo: userInfo)

    }
}
