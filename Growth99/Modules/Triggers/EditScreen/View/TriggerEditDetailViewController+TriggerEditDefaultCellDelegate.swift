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
            }
            defaultNextSelected = true
            triggerdDetailTableView.reloadData()
        }
    }
}

extension TriggerEditDetailViewController: TriggerEditModuleCellDelegate {
    
    func leadButtonModule(cell: TriggerEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        let hasLead = triggerDetailList.contains(where: { $0.cellType == "Lead" })
        if !hasLead {
            DispatchQueue.main.async {
                self.triggerdDetailTableView.beginUpdates()
                if self.triggerDetailList.count > 2 {
                    let indexPathsToDelete = (2..<self.triggerDetailList.count).map { IndexPath(row: $0, section: 0) }
                    self.triggerDetailList.removeSubrange(2..<self.triggerDetailList.count)
                    self.triggerdDetailTableView.deleteRows(at: indexPathsToDelete, with: .fade)
                }
                self.leadTypeSelected = true
                self.moduleSelectionType = moduleType
                self.triggerdDetailTableView.endUpdates()
            }
        }
    }
    
    func patientButtonModule(cell: TriggerEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        let hasPatient = triggerDetailList.contains(where: { $0.cellType == "Appointment" })
        if !hasPatient {
            DispatchQueue.main.async {
                self.triggerdDetailTableView.beginUpdates()
                if self.triggerDetailList.count > 2 {
                    let indexPathsToDelete = (2..<self.triggerDetailList.count).map { IndexPath(row: $0, section: 0) }
                    self.triggerDetailList.removeSubrange(2..<self.triggerDetailList.count)
                    self.triggerdDetailTableView.deleteRows(at: indexPathsToDelete, with: .fade)
                }
                self.patientTypeSelected = true
                self.moduleSelectionType = moduleType
                self.triggerdDetailTableView.endUpdates()
            }
        }
    }
    
    func nextButtonModule(cell: TriggerEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "Appointment" {
            let hasPatient = triggerDetailList.contains(where: { $0.cellType == "Appointment" })
            if !hasPatient {
                DispatchQueue.main.async {
                    self.triggerdDetailTableView.beginUpdates()
                    
                    if self.triggerDetailList.count > 2 {
                        let indexPathsToDelete = (2..<self.triggerDetailList.count).map { IndexPath(row: $0, section: 0) }
                        self.triggerDetailList.removeSubrange(2..<self.triggerDetailList.count)
                        self.triggerdDetailTableView.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                    self.moduleSelectionType = moduleType
                    let emailSMS = TriggerEditDetailModel(cellType: "Appointment", LastName: "")
                    self.triggerDetailList.append(emailSMS)
                    let indexPathToInsert = IndexPath(row: self.triggerDetailList.count - 1, section: 0)
                    self.triggerdDetailTableView.insertRows(at: [indexPathToInsert], with: .fade)
                    self.triggerdDetailTableView.endUpdates()
                    self.scrollToBottom()
                }
            }
        } else if moduleType == "leads" {
            let hasLead = triggerDetailList.contains(where: { $0.cellType == "Lead" })
            if !hasLead {
                DispatchQueue.main.async {
                    self.triggerdDetailTableView.beginUpdates()
                    
                    if self.triggerDetailList.count > 2 {
                        let indexPathsToDelete = (2..<self.triggerDetailList.count).map { IndexPath(row: $0, section: 0) }
                        self.triggerDetailList.removeSubrange(2..<self.triggerDetailList.count)
                        self.triggerdDetailTableView.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                    
                    self.moduleSelectionType = moduleType
                    let emailSMS = TriggerEditDetailModel(cellType: "Lead", LastName: "")
                    self.triggerDetailList.append(emailSMS)
                    
                    let indexPathToInsert = IndexPath(row: self.triggerDetailList.count - 1, section: 0)
                    self.triggerdDetailTableView.insertRows(at: [indexPathToInsert], with: .fade)
                    
                    self.triggerdDetailTableView.endUpdates()
                    self.scrollToBottom()
                }
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
