//
//  AddNewQuestionarieViewController+tableView.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

extension AddNewQuestionarieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getQuestionarieFilterData.count ?? 0
        } else {
            return viewModel?.getQuestionarieDataList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AddNewQuestionarieTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "AddNewQuestionarieTableViewCell", for: indexPath) as! AddNewQuestionarieTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        if isSearch {
            cell.configureCellWithSearch(questionarieVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }
      

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
