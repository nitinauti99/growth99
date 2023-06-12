//
//  PateintsTimeLineViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

extension PateintsTimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getPateintsTimeLineData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PateintsTimeLineTableViewCell()
        cell = pateintsTimeLineTableView.dequeueReusableCell(withIdentifier: "PateintsTimeLineTableViewCell") as! PateintsTimeLineTableViewCell
        cell.configureCell(timeLineVM: viewModel, index: indexPath)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
   
}
