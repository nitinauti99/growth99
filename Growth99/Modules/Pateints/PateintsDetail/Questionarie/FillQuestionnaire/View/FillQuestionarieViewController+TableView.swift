//
//  FillQuestionarieViewController+TableView.swift
//  Growth99
//
//  Created by nitin auti on 22/01/23.
//
import UIKit

extension FillQuestionarieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getQuestionnaireData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let questionType = viewModel?.getQuestionnaireData?[indexPath.row].questionType ?? ""
        let ishowDropDown = viewModel?.getQuestionnaireData?[indexPath.row].showDropDown ?? false
        
        if questionType == "Input" {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "InputTypeTableViewCell") as? InputTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        if(questionType == "Text") {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "TextTypeTableViewCell") as? TextTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        if(questionType == "Yes_No") {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "YesNoTypeTableViewCell") as? YesNoTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
            
        }
        if(questionType == "Date") {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "DateTypeTableViewCell") as? DateTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
    
        if(questionType == "Multiple_Selection_Text" && ishowDropDown == true) {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell") as? MultipleSelectionWithDropDownTypeTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        if(questionType == "Multiple_Selection_Text") {
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTextTypeTableViewCell") as? MultipleSelectionTextTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
     }
    
}
