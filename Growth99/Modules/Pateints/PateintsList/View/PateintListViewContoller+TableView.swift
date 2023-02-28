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
            return viewModel?.getPateintFilterData.count ?? 0
        } else {
            return viewModel?.getPateintData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PateintListTableViewCell()
        cell = pateintListTableView.dequeueReusableCell(withIdentifier: "PateintListTableViewCell") as! PateintListTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCellWithSearch(userVM: viewModel, index: indexPath)
        } else {
            cell.configureCell(userVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let PeteintDetail = PeteintDetailView.viewController()
        PeteintDetail.workflowTaskPatientId = viewModel?.pateintDataAtIndex(index: indexPath.row)?.id ?? 0
        self.navigationController?.pushViewController(PeteintDetail, animated: true)

    }
    
}
