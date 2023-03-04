//
//  ConsentsListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

extension ConsentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.consentsFilterDataList.count ?? 0
        } else {
            return viewModel?.consentsDataList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ConsentsListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "ConsentsListTableViewCell") as! ConsentsListTableViewCell
        if isSearch {
            cell.configureCellWithSearch(consentsVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(consentsVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
  
}
