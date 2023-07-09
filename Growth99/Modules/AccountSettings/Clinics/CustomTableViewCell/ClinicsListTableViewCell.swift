//
//  ClinicsListTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit


protocol ClinicsListCellDelegate: AnyObject {
    func removeSelectedClinic(cell: ClinicsListTableViewCell, index: IndexPath)
    func editClinic(cell: ClinicsListTableViewCell, index: IndexPath)
}

class ClinicsListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    var indexPath = IndexPath()
    var dateFormater: DateFormaterProtocol?
    weak var delegate: ClinicsListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
        
    }
    func configureCell(clinicsFilterList: ClinicsListViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let clinicsFilterListData = clinicsFilterList?.getClinicsFilterDataAtIndex(index: index.row)
        self.nameLabel.text = clinicsFilterListData?.name
        self.id.text = String(clinicsFilterListData?.id ?? 0)
        self.createdDate.text = dateFormater?.serverToLocalDateConverter(date: clinicsFilterListData?.createdAt ?? String.blank)
        self.updatedDate.text = dateFormater?.serverToLocalDateConverter(date: clinicsFilterListData?.updatedAt ?? String.blank)
        self.createdBy.text = clinicsFilterListData?.createdBy
        self.updatedBy.text = clinicsFilterListData?.updatedBy
        indexPath = index
    }
    
    func configureCell(clinicsListData: ClinicsListViewModelProtocol?, index: IndexPath) {
        let clinicsList = clinicsListData?.getClinicsDataAtIndex(index: index.row)
        self.nameLabel.text = clinicsList?.name
        self.id.text = String(clinicsList?.id ?? 0)
        self.createdDate.text = dateFormater?.serverToLocalDateConverter(date: clinicsList?.createdAt ?? String.blank)
        self.updatedDate.text = dateFormater?.serverToLocalDateConverter(date: clinicsList?.updatedAt ?? String.blank)
        self.createdBy.text = clinicsList?.createdBy
        self.updatedBy.text = clinicsList?.updatedBy
        indexPath = index
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date! as Date)
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeSelectedClinic(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editClinic(cell: self, index: indexPath)
    }
}
