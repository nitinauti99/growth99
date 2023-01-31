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
        return bookingHistoryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableViewCell", for: indexPath) as? BookingHistoryTableViewCell else { return UITableViewCell() }
        cell.id.text = String(self.bookingHistoryListData[indexPath.row].id ?? 0)
        cell.patientNameLabel.text = "\(self.bookingHistoryListData[indexPath.row].patientFirstName ?? String.blank) \(self.bookingHistoryListData[indexPath.row].patientLastName ?? String.blank)"
        cell.clinicNameLabel.text = self.bookingHistoryListData[indexPath.row].clinicName
        cell.providerNameLabel.text = self.bookingHistoryListData[indexPath.row].providerName
        cell.typeLabel.text = self.bookingHistoryListData[indexPath.row].appointmentType
        if let data = self.bookingHistoryListData[indexPath.row].source {
            cell.sourceLabel.text = data
        } else {
            cell.sourceLabel.text = "-"
        }
        cell.servicesLabel.text = self.bookingHistoryListData[indexPath.row].serviceList?[0].serviceName
        cell.appointmentDateLabel.text = "\(self.viewModel?.serverToLocal(date: self.bookingHistoryListData[indexPath.row].appointmentStartDate ?? String.blank) ?? "") \(viewModel?.utcToLocal(timeString: self.bookingHistoryListData[indexPath.row].appointmentStartDate ?? String.blank) ?? "")"
        cell.paymetStatusLabel.text = self.bookingHistoryListData[indexPath.row].paymentStatus
        cell.appointmentStatusLabel.text = self.bookingHistoryListData[indexPath.row].appointmentStatus
        cell.createdDate.text = "\(self.viewModel?.serverToLocalCreatedDate(date: self.bookingHistoryListData[indexPath.row].appointmentCreatedDate ?? String.blank) ?? "") \(viewModel?.utcToLocal(timeString: self.bookingHistoryListData[indexPath.row].appointmentCreatedDate ?? String.blank) ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
