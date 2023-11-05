//
//  AddNewConsentsViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

extension AddNewConsentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getConsentsFilterData.count ?? 0
        }else {
            return viewModel?.getConsentsDataList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ConsentsTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "ConsentsTableViewCell", for: indexPath) as! ConsentsTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCellWithSearch(consentsVM: viewModel, index: indexPath, selectedRows: selectedRows)
        } else {
            cell.configureCell(consentsVM: viewModel, index: indexPath, selectedRows: selectedRows)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AddNewConsentsViewController: ConsentsTableViewCellDelegate {
    
    func checkButtonClick(cell: ConsentsTableViewCell, index: IndexPath) {
        let selectedIndexPath = IndexPath(row: index.row, section: 0)
        if let indexToRemove = self.selectedRows.firstIndex(of: selectedIndexPath) {
            self.selectedRows.remove(at: indexToRemove)
        } else {
            self.selectedRows.append(selectedIndexPath)
        }
        self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
    }
}
