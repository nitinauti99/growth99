//
//  AppointmentsViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 10/02/23.
//

import Foundation
import UIKit

extension AppointmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getProfileAppoinmentFilterListData.count ?? 0 == 0 {
                self.appointmentsTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.appointmentsTableView.restore()
            }
            return viewModel?.getProfileAppoinmentFilterListData.count ?? 0
        } else {
            if viewModel?.getProfileAppoinmentListData.count ?? 0 == 0 {
                self.appointmentsTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.appointmentsTableView.restore()
            }
            return viewModel?.getProfileAppoinmentListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppointmentTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self        
        if isSearch {
            cell.configureCell(profileAppointmentList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(profileAppointmentList: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editVC = UIViewController.loadStoryboard("AppointmentListDetailViewController", "AppointmentListDetailViewController") as? AppointmentListDetailViewController else {
            fatalError("Failed to load AppointmentListDetailViewController from storyboard.")
        }
        if isSearch {
            editVC.appointmentId = viewModel?.getProfileAppoinmentFilterListData[indexPath.row].id
        } else {
            editVC.appointmentId = viewModel?.getProfileAppoinmentListData[indexPath.row].id
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
}
