//
//  TaskListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 08/01/23.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var taskName: UILabel!
    @IBOutlet private weak var assignedTo: UILabel!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var deadLine: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
    }
  
    func configureCell(userVM: TasksListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.taskDataAtIndex(index: index.row)
        self.taskName.text = userVM?.name
        self.assignedTo.text = userVM?.userName
        self.id.text = String(userVM?.id ?? 0)
        self.status.text = userVM?.status
        self.createdDate.text =  self.serverToLocal(date: userVM?.createdAt ?? "")
        self.deadLine.text =  self.serverToLocal(date: userVM?.deadLine ?? "")

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date as Date)
    }
    
}
