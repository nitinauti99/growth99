//
//  FormListViewContoller+TableView.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.
//

import Foundation
import UIKit

import Foundation
import UIKit

extension FormListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getFormFilterListData.count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getFormFilterListData.count ?? 0
        } else {
            if viewModel?.getFormListData.count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getFormListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = FormListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "FormListTableViewCell", for: indexPath) as! FormListTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCellisSearch(FormList: viewModel, index: indexPath)
        } else {
            cell.configureCell(FormList: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formDetailContainerView = FormDetailContainerView.viewController()
        formDetailContainerView.workflowFormId = viewModel?.FormDataAtIndex(index: indexPath.row)?.id ?? 0
        self.navigationController?.pushViewController(formDetailContainerView, animated: true)
    }
}
