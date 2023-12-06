//
//  TwoWayTextContainer+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import Foundation
import UIKit

extension TwoWayTextContainer: UITableViewDelegate, UITableViewDataSource {
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel?.getTwoWayData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwoWayListTableViewCell", for: indexPath) as? TwoWayListTableViewCell else {
            return UITableViewCell()
        }
        cell.headerLbl.text = viewModel?.getTwoWayData[indexPath.row].leadFullName ?? ""
        cell.statusLbl.text = viewModel?.getTwoWayData[indexPath.row].leadStatus ?? ""
        
        let inputDateString = viewModel?.getTwoWayData[indexPath.row].lastMessageDate ?? ""
        cell.dateLbl.text = formattedDate(from: inputDateString)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func formattedDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Yesterday)"
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
    }
}
