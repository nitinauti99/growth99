//
//  DeletedDeletedLeadListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

extension DeletedLeadListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearch {
            return viewModel?.getDeletedLeadListFilterData.count ?? 0
        }else{
            return viewModel?.getDeletedLeadListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "DeletedLeadListTableViewCell", for: indexPath) as? DeletedLeadListTableViewCell else { return UITableViewCell() }
        
        if self.isSearch {
            cell.configureCellWithSearch(leadVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(leadVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
