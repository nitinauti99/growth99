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
        
        switch (questionType, ishowDropDown){
       
        case ("Input", false):
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "InputTypeTableViewCell") as? InputTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        
       case ("Text", false):
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "TextTypeTableViewCell") as? TextTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
        
        case ("Yes_No", false):
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "YesNoTypeTableViewCell") as? YesNoTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
            
        case ("Date", false):
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "DateTypeTableViewCell") as? DateTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell
       
//        case ("File", false):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FileTypeTableViewCell", for: indexPath) as? FileTypeTableViewCell else { return UITableViewCell() }
//            cell.configureCell(questionarieVM: viewModel, index: indexPath, id: viewModel?.id ?? 0)
//            cell.delegate = self
//            return cell

        case ("Multiple_Selection_Text", false):
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTextTypeTableViewCell") as? MultipleSelectionTextTypeTableViewCell else { return UITableViewCell() }
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
            return cell

        case ("Multiple_Selection_Text", true):
            guard let cell = questionarieTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionWithDropDownTypeTableViewCell") as? MultipleSelectionWithDropDownTypeTableViewCell else { return UITableViewCell() }
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
