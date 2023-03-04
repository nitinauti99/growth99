//
//  ClinicsListTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

class ClinicsListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
    }
    func configureCell(clinicsFilterList: ClinicsListViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let clinicsFilterListData = clinicsFilterList?.getClinicsFilterDataAtIndex(index: index.row)
        self.nameLabel.text = clinicsFilterListData?.name
        self.id.text = String(clinicsFilterListData?.id ?? 0)
        self.createdDate.text =  self.serverToLocal(date: clinicsFilterListData?.createdAt ?? String.blank)
        self.updatedDate.text =  self.serverToLocal(date: clinicsFilterListData?.updatedAt ?? String.blank)
        self.createdBy.text = clinicsFilterListData?.createdBy
        self.updatedBy.text = clinicsFilterListData?.updatedBy
        indexPath = index
    }
    
    func configureCell(clinicsListData: ClinicsListViewModelProtocol?, index: IndexPath) {
        let clinicsList = clinicsListData?.getClinicsDataAtIndex(index: index.row)
        self.nameLabel.text = clinicsList?.name
        self.id.text = String(clinicsList?.id ?? 0)
        self.createdDate.text =  self.serverToLocal(date: clinicsList?.createdAt ?? String.blank)
        self.updatedDate.text =  self.serverToLocal(date: clinicsList?.updatedAt ?? String.blank)
        self.createdBy.text = clinicsList?.createdBy
        self.updatedBy.text = clinicsList?.updatedBy
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
    
}
