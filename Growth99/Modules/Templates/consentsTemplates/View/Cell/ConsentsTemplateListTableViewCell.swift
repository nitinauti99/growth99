//
//  ConsentsTemplateListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import UIKit

protocol ConsentsTemplateListTableViewCellDelegate: AnyObject {
    func removePatieint(cell: ConsentsTemplateListTableViewCell, index: IndexPath)
}

class ConsentsTemplateListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var editButtonAction: UIButton!

    var dateFormater: DateFormaterProtocol?
    weak var delegate: ConsentsTemplateListTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCellisSearch(consentsTemplateList: ConsentsTemplateListViewModelProtocol?, index: IndexPath) {
        let consentsTemplateList = consentsTemplateList?.consentsTemplateFilterDataAtIndex(index: index.row)
        self.name.text = consentsTemplateList?.name
        self.id.text = String(consentsTemplateList?.id ?? 0)
        self.createdBy.text = consentsTemplateList?.createdBy
        self.updatedBy.text = consentsTemplateList?.updatedBy
        self.createdAt.text = dateFormater?.serverToLocalDateConverter(date: consentsTemplateList?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocalDateConverter(date: consentsTemplateList?.updatedAt ?? String.blank)
        indexPath = index
    }
    
    func configureCell(consentsTemplateList: ConsentsTemplateListViewModelProtocol?, index: IndexPath) {
        let consentsTemplateList = consentsTemplateList?.consentsTemplateDataAtIndex(index: index.row)
        self.name.text = consentsTemplateList?.name
        self.id.text = String(consentsTemplateList?.id ?? 0)
        self.createdBy.text = consentsTemplateList?.createdBy
        self.updatedBy.text = consentsTemplateList?.updatedBy
        self.createdAt.text = dateFormater?.serverToLocalDateConverter(date: consentsTemplateList?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocalDateConverter(date: consentsTemplateList?.updatedAt ?? String.blank)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removePatieint(cell: self, index: indexPath)
    }
    
}
