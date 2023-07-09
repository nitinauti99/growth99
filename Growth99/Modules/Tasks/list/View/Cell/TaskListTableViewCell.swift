//
//  TaskListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 08/01/23.
//

import UIKit

protocol TaskListTableViewCellDelegate: AnyObject {
    func removeTask(cell: TaskListTableViewCell, index: IndexPath)
    func editTask(cell: TaskListTableViewCell, index: IndexPath)
}

class TaskListTableViewCell: UITableViewCell {
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var taskName: UILabel!
    @IBOutlet private weak var assignedTo: UILabel!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var deadLine: UILabel!
    @IBOutlet private weak var subView: UIView!
    weak var delegate: TaskListTableViewCellDelegate?
    var indexPath = IndexPath()
    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
  
    func configureCell(userVM: TasksListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.taskDataAtIndex(index: index.row)
        self.taskName.text = userVM?.name
        self.assignedTo.text = userVM?.userName
        self.id.text = String(userVM?.id ?? 0)
        self.status.text = userVM?.status
        self.createdDate.text =  dateFormater?.serverToLocalforPateints(date: userVM?.createdAt ?? String.blank)
        if userVM?.deadLine != nil {
            self.deadLine.text =  dateFormater?.serverToLocalWithoutTime(date: userVM?.deadLine ?? String.blank)
        }else {
            self.deadLine.text = ""
        }
        indexPath = index
    }
    
    func configureCellWithSearch(userVM: TasksListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.taskFilterDataAtIndex(index: index.row)
        self.taskName.text = userVM?.name
        self.assignedTo.text = userVM?.userName
        self.id.text = String(userVM?.id ?? 0)
        self.status.text = userVM?.status
        self.createdDate.text =  dateFormater?.serverToLocalforPateints(date: userVM?.createdAt ?? String.blank)
        if userVM?.deadLine != nil {
            self.deadLine.text =  dateFormater?.serverToLocalWithoutTime(date: userVM?.deadLine ?? String.blank)
        }else {
            self.deadLine.text = ""
        }
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeTask(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editTask(cell: self, index: indexPath)
    }
}
