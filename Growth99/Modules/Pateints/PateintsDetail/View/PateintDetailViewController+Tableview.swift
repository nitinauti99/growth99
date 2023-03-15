//
//  PateintDetailViewController+Tableview.swift
//  Growth99
//
//  Created by nitin auti on 04/01/23.
//

import Foundation
import UIKit

extension PateintDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            guard let cell = pateintDetailTableView.dequeueReusableCell(withIdentifier: "PateintSMSTemplateTableViewCell") as? PateintSMSTemplateTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = pateintDetailTableView.dequeueReusableCell(withIdentifier: "PateintEmailTemplateTableViewCell") as? PateintEmailTemplateTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            self.emailBody = cell.emailTextFiled.text ?? ""
            return cell
            
        } else if indexPath.section == 2 {
            guard let cell = pateintDetailTableView.dequeueReusableCell(withIdentifier: "PateintCustomEmailTemplateTableViewCell") as? PateintCustomEmailTemplateTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.cnfigureCell(index: indexPath)
            self.emailBody = cell.emailTextView.text
            self.emailSubject = cell.emailTextFiled.text ?? String.blank
            return cell
            
        } else if indexPath.section == 3 {
            guard let cell = pateintDetailTableView.dequeueReusableCell(withIdentifier: "PateintCustomSMSTemplateTableViewCell") as? PateintCustomSMSTemplateTableViewCell else { return UITableViewCell() }
           
            cell.delegate = self
            cell.cnfigureCell(index: indexPath)
            self.smsBody = cell.smsTextView.text
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        }else if indexPath.section == 1 {
            return 220
        }else if indexPath.section == 2 {
            return 320
        }else if indexPath.section == 3 {
            return 240
        } else {
            return 80
        }
    }
    
}
