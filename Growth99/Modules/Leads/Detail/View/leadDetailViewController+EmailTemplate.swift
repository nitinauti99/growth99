//
//  leadDetailViewController+EmailTemplate.swift
//  Growth99
//
//  Created by Nitin Auti on 15/03/23.
//

import Foundation

extension leadDetailViewController: LeadEmailTemplateTableViewCellDelegate, LeadCustomEmailTemplateTableViewCellDelegate{
    
    func selectEmailTemplate(cell: LeadEmailTemplateTableViewCell) {
        let list = viewModel?.emailTemplateListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            cell.emailTextFiled.text = selectedItem?.name
            self?.selctedSmsTemplateId = selectedItem?.id ?? 0
        }
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: cell.emailTextFiledButton, size: CGSize(width: cell.emailTextFiledButton.frame.width, height: (Double(list.count * 44) + 10)), arrowDirection: .up), from: self)
    }
    
    func sendEmailTemplateList() {
        let selctedTemplate = "\(leadId ?? 0)/email-template/\(self.selctedSmsTemplateId)"
        self.viewModel?.sendEmailTemplate(template: selctedTemplate)
    }
    
    func sendCustomEmailTemplateList(cell: LeadCustomEmailTemplateTableViewCell, index: IndexPath) {
        if let txtField = cell.emailTextFiled.text, txtField == ""  {
            cell.emailTextFiled.showError(message: "Email Subject is required.")
            return
        }
        if let txtField = cell.emailTextView.text, txtField == ""  {
            cell.errorLbi.isHidden = false
            return
        }
        self.view.ShowSpinner()
        self.viewModel?.sendCustomEmail(leadId: leadId ?? 0, email: leadData?.Email ?? String.blank, subject: cell.emailTextFiled.text ?? String.blank, body: cell.emailTextView.text)
    }
}
