//
//  BussinessSelectionViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

extension BussinessSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bussinessSelectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = BussinessSelectionListTableViewCell()
        cell = BussinessSelectionTableView.dequeueReusableCell(withIdentifier: "BussinessSelectionListTableViewCell") as! BussinessSelectionListTableViewCell
        let item = bussinessSelectionData[indexPath.row]
        cell.bussinessName.text = item.name
        cell.bussinessImage.image = UIImage(named: "growthCircleIcon")
        cell.buttoneTapCallback = {
            self.loginbuttonPressed(selectedIndex: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}
