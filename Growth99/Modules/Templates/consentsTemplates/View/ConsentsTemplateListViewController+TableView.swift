//
//  ConsentsTemplateListViewController+TableView.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import Foundation
import UIKit

extension ConsentsTemplateListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getConsentsTemplateListData.count ?? 0
        } else {
            return viewModel?.getConsentsTemplateListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ConsentsTemplateListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "ConsentsTemplateListTableViewCell", for: indexPath) as! ConsentsTemplateListTableViewCell
        if isSearch {
            cell.configureCell(consentsTemplateList: viewModel, index: indexPath)
        } else {
            cell.configureCell(consentsTemplateList: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
