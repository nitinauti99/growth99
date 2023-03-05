//
//  CreateLeadViewController+TableViewExtension.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

extension CreateLeadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getLeadUserQuestionnaireList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let questionType = viewModel?.getLeadUserQuestionnaireList?[indexPath.row].questionType ?? ""
        let ishowDropDown = viewModel?.getLeadUserQuestionnaireList?[indexPath.row].showDropDown ?? false
        
        if questionType == "Input" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadInputTypeTableViewCell") as? LeadInputTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        if(questionType == "Text") {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadTextTypeTableViewCell") as? LeadTextTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        if(questionType == "Yes_No") {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadYesNoTypeTableViewCell") as? LeadYesNoTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
            
        }
        if(questionType == "Date") {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadDateTypeTableViewCell") as? LeadDateTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        if(questionType == "Multiple_Selection_Text" && ishowDropDown == true) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMultipleSelectionWithDropDownTypeTableViewCell") as? LeadMultipleSelectionWithDropDownTypeTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        if(questionType == "Multiple_Selection_Text") {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMultipleSelectionTextTypeTableViewCell") as? LeadMultipleSelectionTextTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
