//
//  PateintListViewContoller+TableView.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation
import UIKit

extension PateintListViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
           return pateintFilterData.count
        }else{
            return viewModel?.PateintData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PateintListTableViewCell()
        cell = pateintListTableView.dequeueReusableCell(withIdentifier: "PateintListTableViewCell") as! PateintListTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCell(userVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "PateintDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintDetailViewController") as! PateintDetailViewController
        detailController.workflowTaskPatientId = viewModel?.PateintDataAtIndex(index: indexPath.row)?.id ?? 0
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}
