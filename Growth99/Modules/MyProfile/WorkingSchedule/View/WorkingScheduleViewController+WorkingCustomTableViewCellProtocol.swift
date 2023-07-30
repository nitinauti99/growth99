//
//  WorkingScheduleViewController+WorkingCustomTableViewCellProtocol.swift
//  Growth99
//
//  Created by Nitin Auti on 22/07/23.
//


extension WorkingScheduleViewController: WorkingCellSubclassDelegate {
    
    func selectDayButtonTapped(cell: WorkingCustomTableViewCell, index: IndexPath) {
        self.selectedDays = workingScheduleViewModel?.getWorkingSheduleData[index.section].userScheduleTimings?[index.row].days ?? []
        
        if self.selectedDays.count == 0 {
            selectedDays = days ?? []
        }
        let daysArray = ["MONDAY","TUESDAY","WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: daysArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: selectedDays) { (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.selectDayTextField.text = String.blank
                cell.selectDayTextField.showError(message: "Please select day")
            }
            let sentence = selectedList.joined(separator: ", ")
            cell.selectDayTempTextField.text = sentence
            
            if selectedList.count > 3 {
                cell.selectDayTextField.text = "\(selectedList.count) \(Constant.Profile.days)"
            } else {
                let sentence = selectedList.joined(separator: ", ")
                cell.selectDayTextField.text = sentence
            }
            self.days = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: cell.selectDayButton, size: CGSize(width: cell.selectDayButton.frame.width, height: (Double(daysArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func buttonWorkingtimeFromTapped(cell: WorkingCustomTableViewCell) {
        cell.updateTimeFromTextField(with: workingScheduleViewModel?.timeFormatterString(textField: cell.timeFromTextField) ?? String.blank)
    }
    
    func buttonWorkingtimeToTapped(cell: WorkingCustomTableViewCell) {
        cell.updateTimeToTextField(with: workingScheduleViewModel?.timeFormatterString(textField: cell.timeToTextField) ?? String.blank)
    }
    
    func deleteSelectedWorkingShedule(cell: WorkingCustomTableViewCell, indexPath: IndexPath) {
        self.workingScheduleViewModel?.removeElementFromArray(index: indexPath)
        self.workingListTableView.beginUpdates()
        self.workingListTableView.deleteRows(at: [indexPath], with: .automatic)
        self.workingScrollViewHight.constant = tableViewHeight + 750
        self.workingListTableView.endUpdates()
    }
}
