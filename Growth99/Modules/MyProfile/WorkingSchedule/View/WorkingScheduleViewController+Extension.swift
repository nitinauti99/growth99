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
        if isEmptyResponse == false {
            let item = workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].days
            cell.updateTextLabel(with: item)
            cell.timeFromTextField.text = workingScheduleViewModel?.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate ?? String.blank)
            cell.timeToTextField.text = workingScheduleViewModel?.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate ?? String.blank)
        } else {
            cell.timeFromTextField.text = String.blank
            cell.timeToTextField.text = String.blank
        }
        cell.buttoneRemoveDaysTapCallback = {
            self.deleteDaysRow(selectedSection: indexPath, selectedIndex: indexPath.row)
        }
        cell.delegate = self
        return cell
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
        cell.updateTimeFromTextField(with: workingScheduleViewModel?.timeFormatterString(textField: cell.timeFromTextField) ?? String.blank)
    }
    
    func buttonWorkingtimeToTapped(cell: WorkingCustomTableViewCell) {
        cell.updateTimeToTextField(with: workingScheduleViewModel?.timeFormatterString(textField: cell.timeToTextField) ?? String.blank)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func selectDayButtonTapped(cell: WorkingCustomTableViewCell) {
        let daysArray = ["MONDAY","TUESDAY","WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: daysArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: selectedDays) { (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.selectDayTextField.text = String.blank
                cell.selectDayTextField.showError(message: "Please select day")
            }
            else if selectedList.count > 3 {
                cell.selectDayTextField.text = "\(selectedList.count) \(Constant.Profile.days)"
            } else {
                let sentence = selectedList.joined(separator: ", ")
                cell.selectDayTextField.text = sentence
            }
            self.selectedDays = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: cell.selectDayButton, size: CGSize(width: cell.selectDayButton.frame.width, height: (Double(daysArray.count * 30))), arrowDirection: .up), from: self)
    }
    
}

extension WorkingScheduleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

