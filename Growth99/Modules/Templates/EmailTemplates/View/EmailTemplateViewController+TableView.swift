//
//  EmailTemplateViewController+TableView.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import Foundation
import UIKit

extension EmailTemplateViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getSelectedTemplateFilterData(selectedIndex: segmentedControl.selectedSegmentIndex).count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getSelectedTemplateFilterData(selectedIndex: segmentedControl.selectedSegmentIndex).count ?? 0
        } else {
            if viewModel?.getSelectedTemplate(selectedIndex: segmentedControl.selectedSegmentIndex).count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getSelectedTemplate(selectedIndex: segmentedControl.selectedSegmentIndex).count  ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = EmailTemplatesListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "EmailTemplatesListTableViewCell", for: indexPath) as! EmailTemplatesListTableViewCell
        if isSearch {
            cell.configureCellIsSearch(emailTemplateList: viewModel, index: indexPath, selectedIndex: segmentedControl.selectedSegmentIndex)
        }else{
            cell.configureCell(emailTemplateList: viewModel, index: indexPath, selectedIndex: segmentedControl.selectedSegmentIndex)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
