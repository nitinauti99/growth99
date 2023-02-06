//
//  PatientAppointmentViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation
import UIKit

extension PatientAppointmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return patientsAppointmentListFilterData.count
        } else {
            return viewModel?.getPatientsAppointmentList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PatientAppointmentListTableViewCell", for: indexPath) as? PatientAppointmentListTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(patientAppointmentVM: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        let patientAppointmentListVM = viewModel?.patientListAtIndex(index: indexPath.row)
        editVC.editBookingHistoryData = viewModel?.getPatientsForAppointments
        editVC.appointmentId  = patientAppointmentListVM?.id
        navigationController?.pushViewController(editVC, animated: true)
    }
}
