//
//  ChatSessionListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 10/03/23.
//

import Foundation
import UIKit

extension ChatSessionListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getChatSessionListFilterListData.count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getChatSessionListFilterListData.count ?? 0
        } else {
            if viewModel?.getChatSessionListData.count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getChatSessionListData.count  ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatSessionListTableViewCell", for: indexPath) as? ChatSessionListTableViewCell else { return UITableViewCell() }
        if isSearch {
            cell.configureCellisSearch(chatSessionList: viewModel, index: indexPath)
        } else {
            cell.configureCell(chatSessionList: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "ChatSessionDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "ChatSessionDetailViewController") as! ChatSessionDetailViewController

        if isSearch {
            detailController.chatQuestionareId = viewModel?.getChatSessionListFilterDataAtIndex(index: indexPath.row)?.id ?? 0
        }else{
            detailController.chatQuestionareId = viewModel?.getChatSessionListDataAtIndex(index: indexPath.row)?.id ?? 0
        }
         navigationController?.pushViewController(detailController, animated: true)
     }
}
