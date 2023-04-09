//
//  leadDetailViewController+TableView.swift
//  Growth99
//
//  Created by nitin auti on 04/01/23.
//

import Foundation
import UIKit

extension leadDetailViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel?.getQuestionnaireDetailListData?.count ?? 0
        }else  {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "questionAnswersTableViewCell") as? questionAnswersTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.cnfigureCell(viewModel: viewModel, index: indexPath)
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "LeadSMSTemplateTableViewCell") as? LeadSMSTemplateTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
      
        } else if indexPath.section == 2 {
            
           guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "LeadEmailTemplateTableViewCell") as? LeadEmailTemplateTableViewCell else { return UITableViewCell() }
            cell.delegate = self
           return cell
    
       } else if indexPath.section == 3 {
          guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "LeadCustomEmailTemplateTableViewCell") as? LeadCustomEmailTemplateTableViewCell else { return UITableViewCell() }
         
           cell.delegate = self
           cell.cnfigureCell(index: indexPath)
        return cell
    
       } else if indexPath.section == 4 {
         guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "LeadCustomSMSTemplateTableViewCell") as? LeadCustomSMSTemplateTableViewCell else { return UITableViewCell() }
         
         cell.delegate = self
         cell.cnfigureCell(index: indexPath)
         return cell
      }
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 220
        }else if indexPath.section == 2 {
            return 220
        }else if indexPath.section == 3 {
            return 370
        }else if indexPath.section == 4 {
            return 250
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
