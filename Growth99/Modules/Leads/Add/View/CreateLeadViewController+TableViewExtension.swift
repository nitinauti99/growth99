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
        let questionType = viewModel?.getLeadUserQuestionnaireList?[indexPath.row].questionType ?? ""
        let ishowDropDown = viewModel?.getLeadUserQuestionnaireList?[indexPath.row].showDropDown ?? false
        let allowMultipleSelection = viewModel?.getLeadUserQuestionnaireList?[indexPath.row].allowMultipleSelection ?? false
        
        switch (questionType, ishowDropDown){
       
        case ("Input", false):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadInputTypeTableViewCell", for: indexPath) as? LeadInputTypeTableViewCell else { return LeadInputTypeTableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell

        case ("Text", false):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadTextTypeTableViewCell", for: indexPath) as? LeadTextTypeTableViewCell else { return LeadTextTypeTableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell

        case ("Yes_No", false):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadYesNoTypeTableViewCell", for: indexPath) as? LeadYesNoTypeTableViewCell else { return LeadYesNoTypeTableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
            
        case ("Date", false):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadDateTypeTableViewCell", for: indexPath) as? LeadDateTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell

//        case ("File", false):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FileTypeTableViewCell", for: indexPath) as? FileTypeTableViewCell else { return UITableViewCell() }
//            cell.configureCell(questionarieVM: viewModel, index: indexPath, id: viewModel?.id ?? 0)
//            cell.delegate = self
//            return cell
       
        case ("Multiple_Selection_Text", false):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMultipleSelectionTextTypeTableViewCell", for: indexPath) as? LeadMultipleSelectionTextTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
       
        case ("Multiple_Selection_Text", true):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadMultipleSelectionWithDropDownTypeTableViewCell", for: indexPath) as? LeadMultipleSelectionWithDropDownTypeTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BottomTableViewCell") as? BottomTableViewCell else {
            return UIView()
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
