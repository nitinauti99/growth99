//
//  QuestionnaireTemplatesViewController+TableView.swift
//  Growth99
//
//  Created by nitin auti on 10/02/23.
//

import Foundation
import UIKit

extension QuestionnaireTemplateListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getQuestionnaireTemplateFilterListData.count ?? 0
        } else {
            return viewModel?.getQuestionnaireTemplateListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = QuestionnaireTemplateListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "QuestionnaireTemplateListTableViewCell", for: indexPath) as! QuestionnaireTemplateListTableViewCell
        cell.delegate = self

        if isSearch {
            cell.configureCellisSearch(questionnaireTemplateList: viewModel, index: indexPath)
        }else{
            cell.configureCell(questionnaireTemplateList: viewModel, index: indexPath)
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
