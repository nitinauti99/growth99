//
//  FormDetailTableViewCell+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 27/02/23.
//

import Foundation
import UIKit

extension FormDetailTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = FormQuestionTableViewCell()
        cell = self.questionTableView.dequeueReusableCell(withIdentifier: "FormQuestionTableViewCell", for: indexPath) as! FormQuestionTableViewCell
        let item = questionArray[indexPath.row]
        cell.delegate = self
        cell.configureCell(tableView: tableView, FormList: item, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
