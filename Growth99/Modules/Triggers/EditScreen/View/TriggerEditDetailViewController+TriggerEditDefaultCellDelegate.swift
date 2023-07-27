//
//  TriggerEditDetailViewController+TriggerEditDefaultCellDelegate.swift
//  Growth99
//
//  Created by Sravan Goud on 17/07/23.
//

import Foundation
import UIKit

extension TriggerEditDetailViewController: TriggerEditDefaultCellDelegate {
    func nextButtonDefault(cell: TriggerEditDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter trigger name")
        } else {
            moduleName = cell.massEmailSMSTextField.text ?? String.blank
            if triggerDetailList.count > 2 {
                triggerDetailList.removeSubrange(2..<triggerDetailList.count)
                //cell.parentCell?.finalArray.removeAll()
            }
            triggerdDetailTableView.reloadData()
        }
    }
}

extension TriggerEditDetailViewController: TriggerEditModuleCellDelegate {
    func nextButtonModule(cell: TriggerEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "Appointment" {
            if triggerDetailList.count < 3 {
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Appointment")
                scrollToBottom()
            } else {
                triggerDetailList.removeSubrange(2..<triggerDetailList.count)
                triggerdDetailTableView.reloadData()
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Appointment")
                scrollToBottom()
            }
        } else if moduleType == "leads" {
            if triggerDetailList.count < 3 {
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Lead")
                scrollToBottom()
            } else {
                triggerDetailList.removeSubrange(2..<triggerDetailList.count)
                triggerdDetailTableView.reloadData()
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Lead")
                scrollToBottom()
            }
        }
    }
}

extension TriggerEditDetailViewController: TriggerEditPatientCellDelegate {
    func nextButtonPatient(cell: TriggerEditAppointmentActionTableViewCell, index: IndexPath) {
        addTriggerEditDetailModelCreate()
        scrollToBottom()
    }
}
