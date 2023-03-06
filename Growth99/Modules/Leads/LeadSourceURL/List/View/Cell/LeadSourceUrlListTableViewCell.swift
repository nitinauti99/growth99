//
//  LeadSourceUrlListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import UIKit

protocol LeadSourceUrlListTableViewCellDelegate: AnyObject {
    func removeLeadTag(cell: LeadSourceUrlListTableViewCell, index: IndexPath)
    func editLeadTag(cell: LeadSourceUrlListTableViewCell, index: IndexPath)
}

class LeadSourceUrlListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet weak var subView: UIView!
    
    weak var delegate: LeadSourceUrlListTableViewCellDelegate?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormater = DateFormater()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCellWithSearch(questionarieVM: LeadSourceUrlListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.leadTagsFilterListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.sourceUrl
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    func configureCell(questionarieVM: LeadSourceUrlListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.leadTagsListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.sourceUrl
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeLeadTag(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editLeadTag(cell: self, index: indexPath)
    }
    
}
