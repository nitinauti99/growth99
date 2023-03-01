//
//  QuestionarieViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 01/03/23.
//

import Foundation
import UIKit

extension QuestionarieViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        var cell = QuestionarieTableViewCell()
        cell = questionarieListTableView.dequeueReusableCell(withIdentifier: "QuestionarieTableViewCell") as! QuestionarieTableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionarieVM = viewModel?.getQuestionarieDataAtIndex(index: indexPath.row)

        if questionarieVM?.questionnaireStatus == "Submitted" {
            let displayQuestionnaireVC = UIStoryboard(name: "DisplayQuestionnaireViewContoller", bundle: nil).instantiateViewController(withIdentifier: "DisplayQuestionnaireViewContoller") as! DisplayQuestionnaireViewContoller
            displayQuestionnaireVC.questionnaireId = questionarieVM?.questionnaireId ?? 0
            displayQuestionnaireVC.pateintId = pateintId
            self.navigationController?.pushViewController(displayQuestionnaireVC, animated: true)
        }else{
            let FillQuestionarieVC = UIStoryboard(name: "FillQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "FillQuestionarieViewController") as! FillQuestionarieViewController
            FillQuestionarieVC.questionnaireId = questionarieVM?.questionnaireId ?? 0
            FillQuestionarieVC.pateintId = pateintId
            self.navigationController?.pushViewController(FillQuestionarieVC, animated: true)
        }
            
    }
}
