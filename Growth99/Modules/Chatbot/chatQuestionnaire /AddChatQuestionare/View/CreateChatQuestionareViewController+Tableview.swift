//
//  CreateChatQuestionareViewController+Tableview.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import Foundation
import UIKit

extension CreateChatQuestionareViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getChatQuestionnaireQuestionFilter?.count ?? 0
        } else {
            return viewModel?.getChatQuestionnaireQuestion?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ChatQuestionnaireQuestionTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatQuestionnaireQuestionTableViewCell", for: indexPath) as! ChatQuestionnaireQuestionTableViewCell
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
        let detailController = UIStoryboard(name: "CreateQuestionViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreateQuestionViewContoller") as! CreateQuestionViewContoller
        detailController.screenName = "Edit Screen"
        detailController.chatQuestionareId = chatQuestionareId

        if isSearch {
            detailController.chatQuestionData = viewModel?.chatQuestionnaireQuestionFilterDataAtIndex(index: indexPath.row)
        }else{
            detailController.chatQuestionData = viewModel?.chatQuestionnaireQuestionDataAtIndex(index: indexPath.row)
        }
         navigationController?.pushViewController(detailController, animated: true)
     }
    
}
