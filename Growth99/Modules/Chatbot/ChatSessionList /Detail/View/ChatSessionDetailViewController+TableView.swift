//
//  ChatSessionDetailViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

extension ChatSessionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getChatSessionDetailData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel?.getChatSessionDetailDataAtIndex(index: indexPath.row)
      
        if item?.messageBy == "User" {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatSessionUserTableViewCell", for: indexPath) as? ChatSessionUserTableViewCell else { return UITableViewCell() }
            cell.configureCell(chatSessionList: viewModel, index: indexPath)
            return cell
            
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatSessionBotTableViewCell", for: indexPath) as? ChatSessionBotTableViewCell else { return UITableViewCell() }
            cell.configureCell(chatSessionList: viewModel, index: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
