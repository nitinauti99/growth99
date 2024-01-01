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
        if isSearch {
            if viewModel?.getTwoWayFilterData.count ?? 0 == 0 {
                self.twoWayListTableView.setEmptyMessage()
            } else {
                self.twoWayListTableView.restore()
            }
            return viewModel?.getTwoWayFilterData.count ?? 0
        } else {
            if viewModel?.getTwoWayData.count ?? 0 == 0 {
                self.twoWayListTableView.setEmptyMessage()
            } else {
                self.twoWayListTableView.restore()
            }
            return viewModel?.getTwoWayData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TwoWayListTableViewCell()
        cell = twoWayListTableView.dequeueReusableCell(withIdentifier: "TwoWayListTableViewCell") as! TwoWayListTableViewCell
        if(isSearch) {
            cell.headerLbl.text = viewModel?.getTwoWayFilterData[indexPath.row].leadFullName ?? ""
            cell.statusLbl.text = viewModel?.getTwoWayFilterData[indexPath.row].leadStatus ?? ""
            let inputDateString = viewModel?.getTwoWayFilterData[indexPath.row].lastMessageDate ?? ""
            cell.dateLbl.text = formattedDate(from: inputDateString)
            cell.selectionStyle = .none
        } else {
            cell.headerLbl.text = viewModel?.getTwoWayData[indexPath.row].leadFullName ?? ""
            cell.statusLbl.text = viewModel?.getTwoWayData[indexPath.row].leadStatus ?? ""
            let inputDateString = viewModel?.getTwoWayData[indexPath.row].lastMessageDate ?? ""
            cell.dateLbl.text = formattedDate(from: inputDateString)
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let twoWayTextDetailVC = UIStoryboard(name: "TwoWayTextContainer", bundle: nil).instantiateViewController(withIdentifier: "TwoWayTextViewController") as! TwoWayTextViewController
        if(isSearch) {
            twoWayTextDetailVC.sourceType = viewModel?.getTwoWayFilterData[indexPath.row].source ?? ""
            twoWayTextDetailVC.sourceTemplateType = viewModel?.getTwoWayFilterData[indexPath.row].source ?? ""
            twoWayTextDetailVC.sourceTypeId = viewModel?.getTwoWayFilterData[indexPath.row].sourceId ?? 0
            twoWayTextDetailVC.phoneNumber = viewModel?.getTwoWayFilterData[indexPath.row].sourcePhoneNumber ?? ""
            twoWayTextDetailVC.twoWayListData = viewModel?.getTwoWayFilterData[indexPath.row].auditLogs
            twoWayTextDetailVC.sourceName = viewModel?.getTwoWayFilterData[indexPath.row].leadFullName ?? ""
        } else {
            twoWayTextDetailVC.sourceType = viewModel?.getTwoWayData[indexPath.row].source ?? ""
            twoWayTextDetailVC.sourceTemplateType = viewModel?.getTwoWayData[indexPath.row].source ?? ""
            twoWayTextDetailVC.sourceTypeId = viewModel?.getTwoWayData[indexPath.row].sourceId ?? 0
            twoWayTextDetailVC.phoneNumber = viewModel?.getTwoWayData[indexPath.row].sourcePhoneNumber ?? ""
            twoWayTextDetailVC.twoWayListData = viewModel?.getTwoWayData[indexPath.row].auditLogs
            twoWayTextDetailVC.sourceName = viewModel?.getTwoWayData[indexPath.row].leadFullName ?? ""
        }
        twoWayTextDetailVC.hidesBottomBarWhenPushed = true
        twoWayTextDetailVC.selectedSection = selectedindex
        var listId = [Int]()

        if viewModel?.getTwoWayData[indexPath.row].lastMessageRead == false {
            for item in viewModel?.getTwoWayData[indexPath.row].auditLogs ?? [] {
                if item.direction == "incoming" {
                    listId.append(item.id ?? 0)
                }
            }
        }
        if viewModel?.getTwoWayData[indexPath.row].lastMessageRead == false {
            viewModel?.readMessage(msgData: listId)
        }
        self.navigationController?.pushViewController(twoWayTextDetailVC, animated: true)
    }
    
    func formattedDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
    }
}


extension TwoWayTextContainer: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getTwoWayFilterData(searchText: searchText)
        isSearch = true
        twoWayListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        twoWayListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TwoWayTextContainer:  UIScrollViewDelegate {
     
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isLoadingList = false
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((twoWayListTableView.contentOffset.y + twoWayListTableView.frame.size.height) >= twoWayListTableView.contentSize.height) {
            self.loadMoreItemsForList()
            self.isLoadingList = true
        }
    }
}

