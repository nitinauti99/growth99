//
//  leadListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

extension leadListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getleadPeginationListData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = leadListTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "leadListTableViewCell") as! leadListTableViewCell
        cell.configureCell(leadVM: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "LeadDetailContainerView", bundle: nil).instantiateViewController(withIdentifier: "LeadDetailContainerView") as! LeadDetailContainerView
//        detailController.leadData = viewModel?.leadListDataAtIndex(index: indexPath.row)
//        detailController.leadId = viewModel?.leadListDataAtIndex(index: indexPath.row)?.id ?? 0
        navigationController?.pushViewController(detailController, animated: true)
    }
}
