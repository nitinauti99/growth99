//
//  ServicesListTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol ServiceListCellDelegate: AnyObject {
    func removeSelectedService(cell: ServicesListTableViewCell, index: IndexPath)
    func editServices(cell: ServicesListTableViewCell, index: IndexPath)
}

class ServicesListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    var indexPath = IndexPath()
    var dateFormater: DateFormaterProtocol?
    weak var delegate: ServiceListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()

    }
    func configureCell(serviceFilterList: ServiceListViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let serviceList = serviceFilterList?.getServiceFilterDataAtIndex(index: index.row)
        self.nameLabel.text = serviceList?.name
        self.id.text = String(serviceList?.id ?? 0)
        self.createdDate.text = dateFormater?.serverToLocal(date: serviceList?.createdAt ?? String.blank)
        self.updatedDate.text = dateFormater?.serverToLocal(date: serviceList?.updatedAt ?? String.blank)
        self.createdBy.text = serviceList?.createdBy
        self.updatedBy.text = serviceList?.updatedBy
        indexPath = index
    }
    
    func configureCell(serviceListData: ServiceListViewModelProtocol?, index: IndexPath) {
        let serviceList = serviceListData?.getServiceDataAtIndex(index: index.row)
        self.nameLabel.text = serviceList?.name
        self.id.text = String(serviceList?.id ?? 0)
        self.createdDate.text = dateFormater?.serverToLocal(date: serviceList?.createdAt ?? String.blank)
        self.updatedDate.text = dateFormater?.serverToLocal(date: serviceList?.updatedAt ?? String.blank)
        self.createdBy.text = serviceList?.createdBy
        self.updatedBy.text = serviceList?.updatedBy
        indexPath = index
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

    func utcToLocal(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
        }
        return nil
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeSelectedService(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editServices(cell: self, index: indexPath)
    }
}
