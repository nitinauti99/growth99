//
//  MassEmailandSMSViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 04/03/23.
//


import Foundation
import UIKit

extension MassEmailandSMSViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getMassEmailandSMSFilterData.count ?? 0 == 0 {
                self.massEmailandSMSTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.massEmailandSMSTableView.restore()
            }
            return viewModel?.getMassEmailandSMSFilterData.count ?? 0
        } else {
            if viewModel?.getMassEmailandSMSData.count ?? 0 == 0 {
                self.massEmailandSMSTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.massEmailandSMSTableView.restore()
            }
            return viewModel?.getMassEmailandSMSData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSTableViewCell", for: indexPath) as? MassEmailandSMSTableViewCell else { return UITableViewCell() }
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
            editVC.appointmentId = viewModel?.getMassEmailandSMSFilterData[indexPath.row].id
           // editVC.editMassEmailData = viewModel?.getMassEmailFilterListData[indexPath.row]
        } else {
            editVC.appointmentId = viewModel?.getMassEmailandSMSData[indexPath.row].id
           // editVC.editMassEmailData = viewModel?.getMassEmailListData[indexPath.row]
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
}

