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
