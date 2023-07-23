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
        return workingScheduleViewModel?.getWorkingSheduleData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workingScheduleViewModel?.getWorkingSheduleData[section].userScheduleTimings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingCustomTableViewCell", for: indexPath) as? WorkingCustomTableViewCell else { fatalError("Unexpected Error") }
        
        cell.configureCell(index: indexPath, viewModel: workingScheduleViewModel)
        cell.delegate = self
        return cell
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

