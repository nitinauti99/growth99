//
//  MassSMSViewController+TableView.swift
//  Growth99
//
//  Created by Mahender Reddy on 31/01/23.
//

import Foundation
import UIKit

extension MassSMSViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getMassSMSFilterListData.count ?? 0 == 0 {
                self.massSMSTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.massSMSTableView.restore()
            }
            return viewModel?.getMassSMSFilterListData.count ?? 0
        } else {
            if viewModel?.getMassSMSListData.count ?? 0 == 0 {
                self.massSMSTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.massSMSTableView.restore()
            }
            return viewModel?.getMassSMSListData.sorted(by: { ($0.appointmentCreatedDate ?? String.blank) < ($1.appointmentCreatedDate ?? String.blank)}).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassSMSTableViewCell", for: indexPath) as? MassSMSTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if isSearch {
            cell.configureCell(massSMSFilterList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(massSMSList: viewModel, index: indexPath, isSearch: isSearch)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getMassSMSFilterListData[indexPath.row].id
//            editVC.editMassSMSData = viewModel?.getMassSMSFilterListData[indexPath.row]
        } else {
            editVC.appointmentId = viewModel?.getMassSMSListData[indexPath.row].id
//            editVC.editMassSMSData = viewModel?.getMassSMSListData[indexPath.row]
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
}
