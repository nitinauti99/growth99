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
            return viewModel?.getProfileAppoinmenFilterListData.count ?? 0
        } else {
            return viewModel?.getProfileAppoinmentListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTableViewCell", for: indexPath) as? AppointmentTableViewCell else { return UITableViewCell() }
        cell.delegate = self        
        if isSearch {
            cell.configureCell(profileAppointmentList: viewModel, index: indexPath)
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
        editVC.appointmentId = viewModel?.getProfileAppoinmentListData[indexPath.row].id
        navigationController?.pushViewController(editVC, animated: true)
    }
}