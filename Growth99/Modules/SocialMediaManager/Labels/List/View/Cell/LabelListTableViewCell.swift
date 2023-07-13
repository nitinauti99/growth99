//
//  LabelsTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

protocol LabelListTableViewCellDelegate: AnyObject {
    func removeSocialProfile(cell: LabelListTableViewCell, index: IndexPath)
    func editLabel(cell: LabelListTableViewCell, index: IndexPath)
}

class LabelListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var createDate: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet weak var subView: UIView!
    
    weak var delegate: LabelListTableViewCellDelegate?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateFormater = DateFormater()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCellWithSearch(socialProfileVM: LabelListViewModelProtocol?, index: IndexPath) {
        let socialProfileVM = socialProfileVM?.labelFilterListDataAtIndex(index: index.row)
        self.name.text = socialProfileVM?.name
        self.createDate.text = dateFormater?.serverToLocalDateConverter(date: socialProfileVM?.createdAt ?? String.blank)
        self.id.text = String(socialProfileVM?.id ?? 0)
        indexPath = index
    }
    
    func configureCell(socialProfileVM: LabelListViewModelProtocol?, index: IndexPath) {
        let socialProfileVM = socialProfileVM?.labelListDataAtIndex(index: index.row)
        self.name.text = socialProfileVM?.name
        self.createDate.text = dateFormater?.serverToLocalDateConverter(date: socialProfileVM?.createdAt ?? String.blank)
        self.id.text = String(socialProfileVM?.id ?? 0)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeSocialProfile(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editLabel(cell: self, index: indexPath)
    }
    
}
