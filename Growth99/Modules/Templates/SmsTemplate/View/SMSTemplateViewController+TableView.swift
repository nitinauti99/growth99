//
//  SMSTemplateViewController+TableView.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import Foundation
import UIKit

extension SMSTemplateViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getSelectedTemplateFilterData(selectedIndex: segmentedControl.selectedSegmentIndex).count ?? 0
        } else {
            return viewModel?.getSelectedTemplate(selectedIndex: segmentedControl.selectedSegmentIndex).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SMSTemplatesListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "SMSTemplatesListTableViewCell", for: indexPath) as! SMSTemplatesListTableViewCell
        if isSearch {
            cell.configureCellisSearch(smsTemplateList: viewModel, index: indexPath, selectedIndex: segmentedControl.selectedSegmentIndex)
        }else{
            cell.configureCell(smsTemplateList: viewModel, index: indexPath, selectedIndex: segmentedControl.selectedSegmentIndex)
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
