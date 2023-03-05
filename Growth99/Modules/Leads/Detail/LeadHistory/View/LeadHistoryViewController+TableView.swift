//
//  LeadHistoryViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

extension LeadHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getLeadHistroyFilterData.count ?? 0
        } else {
            return viewModel?.getLeadHistroyData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeadHistoryListTableViewCell", for: indexPath) as? LeadHistoryListTableViewCell else { return UITableViewCell() }
        
        if isSearch {
            cell.configureCellWithSearch(userVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = [ "selectedIndex" : 0 ]
        NotificationCenter.default.post(name: Notification.Name("changeLeadSegment"), object: nil,userInfo: userInfo)
    }
}
