//
//  WorkingScheduleViewController+Extension.swift
//  Growth99
//
//  Created by admin on 06/12/22.
//

import Foundation
import UIKit

extension WorkingScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workingListModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workingListModel?[section].userScheduleTimings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingCustomTableViewCell", for: indexPath) as? WorkingCustomTableViewCell else { fatalError("Unexpected Error") }
            
            cell.workingClinicSelectonButton.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
            cell.workingClinicSelectonButton.tag = (indexPath.section * 1000) + indexPath.row

            if isEmptyResponse == false {
              
                let item = workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].days
                cell.updateTextLabel(with: item)

                cell.workingClinicSelectonButton.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)

                cell.timeToTextField.text = workingScheduleViewModel.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate ?? String.blank)
                
                cell.timeFromTextField.text = workingScheduleViewModel.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate ?? String.blank)
                
            } else {
                cell.timeFromTextField.text = String.blank
                cell.timeToTextField.text = String.blank
                cell.workingClinicTextLabel.text = Constant.Profile.selectDay
            }
            cell.buttoneRemoveDaysTapCallback = {
                self.deleteDaysRow(selectedSection: indexPath, selectedIndex: indexPath.row)
            }
            cell.delegate = self
            return cell
        }
    
    @objc func myTargetFunction(sender: UIButton) {
        let daysArray = ["MONDAY","TUESDAY","WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
      
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: daysArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        
        let selectedArray = workingListModel?[section].userScheduleTimings?[row].days
        selectionMenu.setSelectedItems(items: selectedArray ?? []) { [weak self] (selectedItem, index, selected, selectedList) in
            print(selectedList)
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let workingCell = self?.workingListTableView.cellForRow(at: cellIndexPath) as? WorkingCustomTableViewCell {
                if selectedList.count == 0 {
                    workingCell.workingClinicTextLabel.text = Constant.Profile.selectDay
                }
                else if selectedList.count > 3 {
                    workingCell.workingClinicTextLabel.text = "\(selectedList.count) \(Constant.Profile.days)"
                    workingCell.supportWorkingClinicTextLabel.text = selectedList.joined(separator: ",")
                } else {
                    let sentence = selectedList.joined(separator: ", ")
                    workingCell.workingClinicTextLabel.text = sentence
                    workingCell.supportWorkingClinicTextLabel.text = selectedList.joined(separator: ",")
                }
            }
         }
        
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(daysArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func deleteDaysRow(selectedSection: IndexPath, selectedIndex: Int) {
        workingListTableView.beginUpdates()
        workingListModel?[selectedSection.section].userScheduleTimings?.remove(at: selectedIndex)
        workingListTableView.deleteRows(at: [selectedSection], with: .fade)
        workingListTableView.endUpdates()
        if workingListModel?[selectedSection.section].userScheduleTimings?.count ?? 0 == 0 {
            workingListModel?.removeAll()
        }
        workingScrollViewHight.constant = tableViewHeight + 650
    }

    func buttonWorkingtimeFromTapped(cell: WorkingCustomTableViewCell) {
        guard let indexPath = workingListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = workingListTableView.cellForRow(at: cellIndexPath) as? WorkingCustomTableViewCell {
            vacationCell.updateTimeFromTextField(with: workingScheduleViewModel.timeFormatterString(textField: cell.timeFromTextField))
        }
    }
    
    func buttonWorkingtimeToTapped(cell: WorkingCustomTableViewCell) {
        guard let indexPath = workingListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = workingListTableView.cellForRow(at: cellIndexPath) as? WorkingCustomTableViewCell {
            vacationCell.updateTimeToTextField(with: workingScheduleViewModel.timeFormatterString(textField: cell.timeToTextField))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

}

extension WorkingScheduleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

