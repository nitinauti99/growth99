//
//  leadDetailViewController+SMSTemplate.swift
//  Growth99
//
//  Created by Nitin Auti on 15/03/23.
//

import Foundation

extension leadDetailViewController: LeadSMSTemplateTableViewCellDelegate,
                                    LeadCustomSMSTemplateTableViewCellDelegate {
    
    func selectSMSTemplate(cell: LeadSMSTemplateTableViewCell) {
        let list = viewModel?.smsTemplateListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] ( selectedItem, index, selected, selectedList) in
            cell.smsTextFiled.text = selectedItem?.name
            self?.selctedSmsTemplateId = selectedItem?.id ?? 0
        }
        selectionMenu.reloadInputViews()
        selectionMenu.show(style: .popover(sourceView: cell.smsTextFiledButton, size: CGSize(width: cell.smsTextFiledButton.frame.width, height: (Double(list.count * 44) + 10)), arrowDirection: .up), from: self)
    }
    
    func sendSMSTemplateList(cell: LeadSMSTemplateTableViewCell) {
        let selctedTemplate =  "\(leadId ?? 0)/sms-template/\(self.selctedSmsTemplateId)"
        
        if cell.smsTextFiled.text == "" {
            return
        }
        self.view.ShowSpinner()
        self.viewModel?.sendSMSTemplate(template: selctedTemplate)
    }
    
    func sendCustomSMSTemplateList(cell: LeadCustomSMSTemplateTableViewCell, index: IndexPath) {
        if let txtField = cell.smsTextView.text, txtField == "" {
            cell.errorLbi.isHidden = false
            return
        }
        self.view.ShowSpinner()
        viewModel?.sendCustomSMS(leadId: leadData?.id ?? 0, phoneNumber: leadData?.PhoneNumber ?? String.blank, body: cell.smsTextView.text)
    }
}
