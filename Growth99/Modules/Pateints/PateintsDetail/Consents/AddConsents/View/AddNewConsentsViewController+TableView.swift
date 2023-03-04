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
        if isSearch {
            cell.configureCell(consentsVM: viewModel, index: indexPath)
        } else {
            cell.configureCell(consentsVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
