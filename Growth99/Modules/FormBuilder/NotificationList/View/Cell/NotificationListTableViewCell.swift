//
//  NotificationListsTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

protocol NotificationListTableViewCellDelegate: AnyObject {
    func removeNotification(cell: NotificationListTableViewCell, index: IndexPath)
}

class NotificationListTableViewCell: UITableViewCell {
    @IBOutlet private weak var notificationType: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var toEmail: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var editButtonAction: UIButton!

    weak var delegate: NotificationListTableViewCellDelegate?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    func configureCell(NotificationList: NotificationListViewModelProtocol?, index: IndexPath) {
        let NotificationList = NotificationList?.getNotificationListDataAtIndexPath(index: index.row)
        self.notificationType.text = NotificationList?.notificationType
        self.phoneNumber.text = String(NotificationList?.id ?? 0)
        self.toEmail.text = NotificationList?.toEmail
        self.createdDate.text = dateFormater?.serverToLocal(date: NotificationList?.createdAt ?? String.blank)
        self.updatedDate.text =  dateFormater?.serverToLocal(date: NotificationList?.updatedAt ?? String.blank)
        indexPath = index
    }
    
    func configureCellisSearch(NotificationList: NotificationListViewModelProtocol?, index: IndexPath) {
        let NotificationList = NotificationList?.getNotificationFilterDataAtIndexPath(index: index.row)
        self.notificationType.text = NotificationList?.notificationType
        self.phoneNumber.text = String(NotificationList?.id ?? 0)
        self.toEmail.text = NotificationList?.toEmail
        self.createdDate.text = dateFormater?.serverToLocal(date: NotificationList?.createdAt ?? String.blank)
        self.updatedDate.text =  dateFormater?.serverToLocal(date: NotificationList?.updatedAt ?? String.blank)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeNotification(cell: self, index: indexPath)
    }
}

