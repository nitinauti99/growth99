//
//  CombineTimeLineViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

extension CombineTimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getLeadTimeLineData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadCombineTimeLineTableViewCell", for: indexPath) as? LeadCombineTimeLineTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(timeLineVM: viewModel, index: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LeadCreationCombineTimeLineTableViewCell") as? LeadCreationCombineTimeLineTableViewCell else {
            return UIView()
        }
        cell.configureCell(timeLineVM: viewModel, index: section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
