//
//  PateintsTagListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import UIKit

protocol PateintsTagListTableViewCellDelegate: AnyObject {
    func removePatieintTag(cell: PateintsTagListTableViewCell, index: IndexPath)
    func editPatieintTag(cell: PateintsTagListTableViewCell, index: IndexPath)
}

class PateintsTagListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet weak var subView: UIView!
    
    weak var delegate: PateintsTagListTableViewCellDelegate?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormater = DateFormater()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCellWithSearch(questionarieVM: PateintsTagsListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.pateintsTagsFilterListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.name
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    func configureCell(questionarieVM: PateintsTagsListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.pateintsTagsListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.name
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removePatieintTag(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editPatieintTag(cell: self, index: indexPath)
    }
    
}
