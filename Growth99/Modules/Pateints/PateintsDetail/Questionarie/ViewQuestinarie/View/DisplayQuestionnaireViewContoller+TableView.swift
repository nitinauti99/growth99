//
//  DisplayQuestionnaireViewContoller+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 01/03/23.
//

import Foundation

extension DisplayQuestionnaireViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getQuestionnaireData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = DisplayQuestionnaireTableViewCell()
        cell = questionnaireTableView.dequeueReusableCell(withIdentifier: "DisplayQuestionnaireTableViewCell") as! DisplayQuestionnaireTableViewCell
      
        cell.configureCell(questionnaireVM: viewModel, index: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}
