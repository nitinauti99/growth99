//
//  MassEmailViewController+TableView.swift
//  Growth99
//
//  Created by Mahender Reddy on 31/01/23.
//

import Foundation
import UIKit

extension MassEmailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getMassEmailFilterListData.count ?? 0 == 0 {
                self.massEmailTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.massEmailTableView.restore()
            }
            return viewModel?.getMassEmailFilterListData.count ?? 0
        } else {
            if viewModel?.getMassEmailListData.count ?? 0 == 0 {
                self.massEmailTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.massEmailTableView.restore()
            }
            return viewModel?.getMassEmailListData.sorted(by: { ($0.appointmentCreatedDate ?? String.blank) < ($1.appointmentCreatedDate ?? String.blank)}).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailTableViewCell", for: indexPath) as? MassEmailTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if isSearch {
            cell.configureCell(massEmailFilterList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(massEmailList: viewModel, index: indexPath, isSearch: isSearch)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getMassEmailFilterListData[indexPath.row].id
           // editVC.editMassEmailData = viewModel?.getMassEmailFilterListData[indexPath.row]
        } else {
            editVC.appointmentId = viewModel?.getMassEmailListData[indexPath.row].id
           // editVC.editMassEmailData = viewModel?.getMassEmailListData[indexPath.row]
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
}
