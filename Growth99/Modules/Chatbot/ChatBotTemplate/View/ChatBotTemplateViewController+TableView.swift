//
//  ChatBotTemplateViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 11/03/23.
//

import Foundation
import UIKit

extension ChatBotTemplateViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getChatBotTemplateListData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatBotTemplateTableViewCell", for: indexPath) as? ChatBotTemplateTableViewCell else { return UITableViewCell() }
       
        cell.configureCell(chatBotTemplateList: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
