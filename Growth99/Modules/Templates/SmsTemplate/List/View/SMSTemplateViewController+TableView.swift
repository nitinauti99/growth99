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
            return viewModel?.getSelectedTemplate(selectedIndex: segmentedControl.selectedSegmentIndex).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SMSTemplatesListTableViewCell", for: indexPath) as? SMSTemplatesListTableViewCell else { return UITableViewCell()}
       
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
        let createSMSTemplateVC = UIStoryboard(name: "CreateSMSTemplateViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateSMSTemplateViewController") as! CreateSMSTemplateViewController
        createSMSTemplateVC.screenTitle = "Edit"
       
        if isSearch {
            createSMSTemplateVC.smsTemplateId = viewModel?.getTemplateFilterDataAtIndexPath(index: indexPath.row, selectedIndex: segmentedControl.selectedSegmentIndex)?.id ?? 0
        } else {
            createSMSTemplateVC.smsTemplateId = viewModel?.getTemplateDataAtIndexPath(index: indexPath.row, selectedIndex: segmentedControl.selectedSegmentIndex)?.id ?? 0
        }
        createSMSTemplateVC.selectedIndex = segmentedControl.selectedSegmentIndex
        navigationController?.pushViewController(createSMSTemplateVC, animated: true)
    }
    
}
