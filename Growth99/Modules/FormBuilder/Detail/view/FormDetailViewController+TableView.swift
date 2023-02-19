//
//  FormDetailViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 16/02/23.
//

import Foundation
import UIKit

extension FormDetailViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return viewModel?.getFormDetailData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = FormDetailTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "FormDetailTableViewCell", for: indexPath) as! FormDetailTableViewCell
        cell.delegate = self
        cell.configureCell(tableView: tableView, FormList: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let formDetailContainerView = FormDetailContainerView.viewController()
//        formDetailContainerView.workflowFormId = viewModel?.FormDataAtIndex(index: indexPath.row)?.id ?? 0
//        self.navigationController?.pushViewController(formDetailContainerView, animated: true)
    }
}

