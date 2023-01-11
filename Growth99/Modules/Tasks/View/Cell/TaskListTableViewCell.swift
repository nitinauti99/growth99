//
//  TaskListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 08/01/23.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var lastName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
    }
  
    func configureCell(userVM: TasksListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.taskDataAtIndex(index: index.row)
        self.firstName.text = userVM?.name
        self.lastName.text = userVM?.userName
        self.id.text = String(userVM?.id ?? 0)
        self.email.text = userVM?.status
        self.createdDate.text =  self.serverToLocal(date: userVM?.createdAt ?? "")
        self.updatedDate.text =  self.serverToLocal(date: userVM?.deadLine ?? "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date! as Date)
    }
    
}
