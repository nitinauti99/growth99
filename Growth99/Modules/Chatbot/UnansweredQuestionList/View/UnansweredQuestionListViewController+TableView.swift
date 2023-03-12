//
//  UnansweredQuestionListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

extension UnansweredQuestionListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getUnansweredQuestionFilterListData.count ?? 0
        } else {
            return viewModel?.getUnansweredQuestionListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnansweredQuestionListTableViewCell", for: indexPath) as? UnansweredQuestionListTableViewCell else { return UITableViewCell() }
        if isSearch {
            cell.configureCellisSearch(unansweredQuestionList: viewModel, index: indexPath)
        } else {
            cell.configureCell(unansweredQuestionList: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
