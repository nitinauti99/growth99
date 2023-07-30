//
//  BookingHistoryViewController+TableView.swift
//  Growth99
//
//  Created by Mahender Reddy on 31/01/23.
//

import Foundation
import UIKit

extension BookingHistoryViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getBookingHistoryFilterListData.count ?? 0 == 0 {
                self.bookingHistoryTableView.setEmptyMessage()
            } else {
                self.bookingHistoryTableView.restore()
            }
            return viewModel?.getBookingHistoryFilterListData.count ?? 0
        } else {
            if viewModel?.getBookingHistoryListData.count ?? 0 == 0 {
                self.bookingHistoryTableView.setEmptyMessage()
            } else {
                self.bookingHistoryTableView.restore()
            }
            return viewModel?.getBookingHistoryListData.sorted(by: { ($0.appointmentCreatedDate ?? String.blank) < ($1.appointmentCreatedDate ?? String.blank)}).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableViewCell", for: indexPath) as? BookingHistoryTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if isSearch {
            cell.configureCell(bookingHistoryFilterList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(bookingHistoryList: viewModel, index: indexPath, isSearch: isSearch)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getBookingHistoryFilterListData[indexPath.row].id
            editVC.editBookingHistoryData = viewModel?.getBookingHistoryFilterListData[indexPath.row]
        } else {
            editVC.appointmentId = viewModel?.getBookingHistoryListData[indexPath.row].id
            editVC.editBookingHistoryData = viewModel?.getBookingHistoryListData[indexPath.row]
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
}

extension BookingHistoryViewContoller: BookingHistoryListTableViewCellDelegate {
    func editAppointment(cell: BookingHistoryTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getBookingHistoryFilterListData[index.row].id
            editVC.editBookingHistoryData = viewModel?.getBookingHistoryFilterListData[index.row]
        } else {
            editVC.appointmentId = viewModel?.getBookingHistoryListData[index.row].id
            editVC.editBookingHistoryData = viewModel?.getBookingHistoryListData[index.row]
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func removeAppointment(cell: BookingHistoryTableViewCell, index: IndexPath) {
        var selectedClinicId = Int()
        if isSearch {
            selectedClinicId = self.viewModel?.getBookingHistoryFilterDataAtIndex(index: index.row)?.id ?? 0
            let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete \(viewModel?.getBookingHistoryFilterDataAtIndex(index: index.row)?.patientFirstName ?? String.blank) \(viewModel?.getBookingHistoryFilterDataAtIndex(index: index.row)?.patientLastName ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedBookingHistory(bookingHistoryId: selectedClinicId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            selectedClinicId = self.viewModel?.getBookingHistoryDataAtIndex(index: index.row)?.id ?? 0
            let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete \(viewModel?.getBookingHistoryDataAtIndex(index: index.row)?.patientFirstName ?? String.blank) \(viewModel?.getBookingHistoryDataAtIndex(index: index.row)?.patientLastName ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedBookingHistory(bookingHistoryId: selectedClinicId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func appointmentRemovedSuccefully(message: String, status: Int){
        if status == 200 {
            self.view.showToast(message: message, color: UIColor().successMessageColor())
        } else {
            self.view.showToast(message: message, color: .red)
        }
        self.getBookingHistory()
    }
}
