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

    
    var dateFormater : DateFormaterProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }
  
    func configureCell(userVM: TasksListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.taskDataAtIndex(index: index.row)
        self.taskName.text = userVM?.name
        self.assignedTo.text = userVM?.userName
        self.id.text = String(userVM?.id ?? 0)
        self.status.text = userVM?.status
        self.createdDate.text =  dateFormater?.serverToLocal(date: userVM?.createdAt ?? String.blank)
        self.deadLine.text =  dateFormater?.serverToLocalWithoutTime(date: userVM?.deadLine ?? String.blank)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
