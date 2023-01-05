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
            return patientQuestionList.count
        }else  {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let item = patientQuestionList[indexPath.row]
            guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "questionAnswersTableViewCell") as? questionAnswersTableViewCell else { return UITableViewCell() }
            
            cell.qutionNameLbi.text = item.questionName
            cell.ansLbi.text = item.answerText
            cell.editButton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
            cell.editButton.isHidden = true
            if item.questionName == "First Name" || item.questionName == "Last Name" || item.questionName == "Email" || item.questionName == "Phone Number" {
                cell.editButton.isHidden = false
                let image = UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate)
                cell.editButton.setImage(image, for: .normal)
                cell.editButton.tintColor = UIColor.init(hexString: "009EDE")
            }
            return cell
       
        } else if indexPath.section == 1 {
            guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "SMSTemplateTableViewCell") as? SMSTemplateTableViewCell else { return UITableViewCell() }
            cell.smsSendButton.layer.cornerRadius = 5
            cell.smsSendButton.layer.borderWidth = 1
            cell.smsSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
            cell.smsSendButton.addTarget(self, action: #selector(self.sendSmsTemplateList(_:)), for:.touchUpInside)
         
            cell.smsTextFiled.addTarget(self, action: #selector(leadDetailViewController.smsTemplateList(_:)), for:.touchDown)
            cell.smsTextFiled.text = "Selecte SMS template"
            
            return cell
      
        } else if indexPath.section == 2 {
            
           guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "EmailTemplateTableViewCell") as? EmailTemplateTableViewCell else { return UITableViewCell() }
           cell.emailSendButton.layer.cornerRadius = 5
           cell.emailSendButton.layer.borderWidth = 1
           cell.emailSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
           cell.emailSendButton.addTarget(self, action: #selector(self.sendEmailTemplateList(_:)), for:.touchUpInside)

           cell.emailTextFiled.addTarget(self, action: #selector(leadDetailViewController.emailTemplateList(_:)), for:.touchDown)
            cell.emailTextFiled.text = "Select Email template"

           return cell
    
       } else if indexPath.section == 3 {
          guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "CustomEmailTemplateTableViewCell") as? CustomEmailTemplateTableViewCell else { return UITableViewCell() }
          cell.emailSendButton.layer.cornerRadius = 5
          cell.emailSendButton.layer.borderWidth = 1
          cell.emailSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
          cell.emailSendButton.addTarget(self, action: #selector(self.sendCustomEmailTemplateList(_:)), for:.touchUpInside)
           emailBody = cell.emailTextView.text
           emailSubject = cell.emailTextFiled.text ?? ""
           cell.emailSendButton.tag = indexPath.row
           cell.errorLbi.isHidden = true

        return cell
    
       } else if indexPath.section == 4 {
         guard let cell = anslistTableView.dequeueReusableCell(withIdentifier: "CustomSMSTemplateTableViewCell") as? CustomSMSTemplateTableViewCell else { return UITableViewCell() }
         cell.smsSendButton.layer.cornerRadius = 5
         cell.smsSendButton.layer.borderWidth = 1
         cell.smsSendButton.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
         smsBody = cell.smsTextView.text
         cell.smsSendButton.addTarget(self, action: #selector(self.sendCustomSMSTemplateList(_:)), for:.touchUpInside)
           cell.smsSendButton.tag = indexPath.row
           cell.errorLbi.isHidden = true

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
            return 320
        }else if indexPath.section == 4 {
            return 240
        } else {
            return 80
        }
    }
    
}
