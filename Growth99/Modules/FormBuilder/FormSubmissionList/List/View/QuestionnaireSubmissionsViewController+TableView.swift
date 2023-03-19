//
//  QuestionnaireSubmissionsViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import Foundation
import UIKit

extension QuestionnaireSubmissionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.getQuestionarieDataList.count ?? 0 == 0 {
            self.questionarieListTableView.setEmptyMessage()
        } else {
            self.questionarieListTableView.restore()
        }
        return viewModel?.getQuestionarieDataList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = questionarieListTableView.dequeueReusableCell(withIdentifier: "QuestionnaireSubmissionsTableViewCell") as? QuestionnaireSubmissionsTableViewCell  else {
            return UITableViewCell()
        }
        cell.configureCell(questionarieVM: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionarieVM = viewModel?.getQuestionarieDataAtIndex(index: indexPath.row)
        let displayQuestionnaireVC = UIStoryboard(name: "DisplayQuestionnaireqsubmissionsViewContoller", bundle: nil).instantiateViewController(withIdentifier: "DisplayQuestionnaireqsubmissionsViewContoller") as! DisplayQuestionnaireqsubmissionsViewContoller
        displayQuestionnaireVC.questionnaireId = questionarieVM?.id ?? 0
        self.navigationController?.pushViewController(displayQuestionnaireVC, animated: true)
    }
}
