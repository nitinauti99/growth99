//
//  chatQuestionnaireViewContoller+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

extension chatQuestionnaireViewContoller: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getChatQuestionnaireFilterListData.count ?? 0
        } else {
            return viewModel?.getChatQuestionnaireData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = chatQuestionnaireTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "chatQuestionnaireTableViewCell", for: indexPath) as! chatQuestionnaireTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCellisSearch(chatQuestionnaire: viewModel, index: indexPath)
        } else {
            cell.configureCell(chatQuestionnaire: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "CreateChatQuestionareViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateChatQuestionareViewController") as! CreateChatQuestionareViewController
        detailController.screenName = "Edit Screen"
       
        if isSearch {
            detailController.chatQuestionareId = viewModel?.chatQuestionnaireFilterDataAtIndex(index: indexPath.row)?.id ?? 0
        }else{
            detailController.chatQuestionareId = viewModel?.chatQuestionnaireDataAtIndex(index: indexPath.row)?.id ?? 0
        }
         navigationController?.pushViewController(detailController, animated: true)
        
    }
}
