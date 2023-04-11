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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        }else{
            return viewModel?.getFormDetailData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            var cell = CreateQuestionnaireTableViewCell()
            cell = self.tableView.dequeueReusableCell(withIdentifier: "CreateQuestionnaireTableViewCell", for: indexPath) as! CreateQuestionnaireTableViewCell
            cell.delegate = self
            cell.configureCell(tableView: tableView, viewModel: viewModel, index: indexPath)
            return cell
        }else{
            var cell = FormDetailTableViewCell()
            cell = self.tableView.dequeueReusableCell(withIdentifier: "FormDetailTableViewCell", for: indexPath) as! FormDetailTableViewCell
            cell.delegate = self
            cell.configureCell(tableView: tableView, FormList: viewModel, index: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

